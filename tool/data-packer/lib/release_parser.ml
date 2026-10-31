open Data_intf.Release

type metadata = {
  kind : kind;
  version : string;
  stdlib_version : string option;
  date : string;
  is_latest : bool option;
  is_prerelease : bool option;
  is_lts : bool option;
  intro : string;
  highlights : string;
}
[@@deriving
  of_yaml,
    stable_record ~version:t ~remove:[ intro; highlights ]
      ~modify:[ is_latest; is_prerelease; is_lts ]
      ~add:
        [
          stdlib_version;
          intro_md;
          intro_html;
          highlights_md;
          highlights_html;
          body_md;
          body_html;
        ]]

let of_metadata m =
  metadata_to_t m ~intro_md:m.intro
    ~intro_html:
      (m.intro |> Markdown.Content.of_string |> Markdown.Content.render)
    ~highlights_md:m.highlights
    ~highlights_html:
      (m.highlights |> Markdown.Content.of_string
      |> Markdown.Content.render ~syntax_highlighting:true)
    ~modify_is_latest:(Option.value ~default:false)
    ~modify_is_prerelease:(Option.value ~default:false)
    ~modify_is_lts:(Option.value ~default:false)

let sort_by_decreasing_version (x : t) (y : t) =
  let to_list s = List.map int_of_string_opt @@ String.split_on_char '.' s in
  compare (to_list y.version) (to_list x.version)

let decode (fpath, (head, body_md)) =
  let metadata =
    metadata_of_yaml head |> Result.map_error (Utils.where fpath)
  in
  let body_html =
    body_md |> Markdown.Content.of_string
    |> Markdown.Content.render ~syntax_highlighting:true
  in
  Result.map (of_metadata ~body_md ~body_html) metadata

let sort_by_date (r : t) (r' : t) =
  Timedesc.Date.(compare (of_iso8601_exn r'.date) (of_iso8601_exn r.date))

let all () =
  Utils.map_md_files decode "releases/*.md"
  |> List.sort sort_by_date

let is_coq_or_rocq (r : t) = r.kind == `Coq || r.kind == `Rocq
let is_coq_or_rocq_platform (r : t) = r.kind == `CoqPlatform || r.kind == `RocqPlatform
let is_rocq (r : t) = r.kind == `Rocq
let is_rocq_stdlib (r : t) = r.kind == `Stdlib

let selected () =
  let all = all () in
  let latest =
    try List.find (fun (r : t) -> is_coq_or_rocq r && r.is_latest && not r.is_prerelease) all
    with Not_found ->
      raise
        (Invalid_argument
           "none of the Coq/Rocq releases in data/releases is marked with is_latest: \
            true")
  in
  let latest_prerelease = List.find_opt (fun (r : t) -> is_rocq r && r.is_prerelease && r.is_latest) all in
  let latest_stdlib =
    try List.find (fun (r : t) -> is_rocq_stdlib r && r.is_latest) all 
    with Not_found -> 
      raise
        (Invalid_argument
          "none of the Stdlib releases in data/releases is marked with is_latest: \
           true")
  in
  let latest_platform =
    match List.sort sort_by_date (List.find_all (fun (r : t) -> is_coq_or_rocq_platform r) all) with
    | hd :: _ -> hd
    | _ ->
      raise
        (Invalid_argument
           "none of the Coq/Rocq Platform releases in data/releases is marked with is_latest: \
            true")
  in
  let lts =
    try List.find (fun (r : t) -> r.is_lts) all
    with Not_found ->
      raise
        (Invalid_argument
           "none of the releases in data/releases is marked with is_lts: true")
  in
  (latest, latest_prerelease, latest_stdlib, latest_platform, lts)
