open Rocqproverorg.Import
open Data_intf.Governance
open Member

type metadata = {
  teams : team list;
  working_groups : team list; [@default []]
}
[@@deriving of_yaml]

let merge_teams (reference : team list) (additions : team list) =
  let member_key (m : Member.t) = Member.key ?github:m.github m.name in
  (* The team ids are used to determine if a team is already present
   * in the reference list, including as a subteam.
   * If that's the case, we merge the members of the two teams.
   * The github keys are used to determine if a member is already present
   * in the reference team. *)
  (* For each team in the additions list, we check if it is already present
   * in the reference list (including as a subteam). *)
  let rec merge_team reference team =
    let rec merge_subteam reference team =
      match reference with
      | [] -> []
      | r :: rs ->
          if r.id = team.id then
            {
              r with
              members =
                List.append r.members
                  (List.filter
                     (fun m ->
                       not
                         (List.exists
                            (fun m' -> member_key m' = member_key m)
                            r.members))
                     team.members);
            }
            :: rs
          else if r.subteams = [] then r :: merge_subteam rs team
          else
            { r with subteams = merge_subteam r.subteams team }
            :: merge_team rs team
    in
    merge_subteam reference team
  in
  List.fold_left merge_team reference additions

let teams file =
  let file = file in
  let result =
    let ( let* ) = Result.bind in
    let* yaml = Utils.yaml_file file in
    metadata_of_yaml yaml
  in
  result
  |> Result.map_error (Utils.where file)
  |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let template () =
  let governance = teams "governance.yml" in
  let github_teams = teams "github-teams-simplified.json" in
  Format.asprintf
    {|
include Data_intf.Governance
let teams = %a

let working_groups = %a
|}
    (Fmt.brackets (Fmt.list pp_team ~sep:Fmt.semi))
    (merge_teams governance.teams github_teams.teams)
    (Fmt.brackets (Fmt.list pp_team ~sep:Fmt.semi))
    governance.working_groups
