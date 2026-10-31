(* Data module using binary blob embedding

   The blob is built by the data-packer (tool/data-packer), embedded in the
   binary via an .incbin assembly directive, and deserialised once at startup
   with Marshal. *)

external get_blob_check : unit -> bool = "caml_rocqproverorg_data_blob_check"

external get_blob_raw :
  unit ->
  (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t
  = "caml_rocqproverorg_data_blob"

let data : Data_intf.All_data.t =
  if not (get_blob_check ()) then
    failwith "Data blob is not properly initialized";
  (* Type-safe by construction: the packer of the same build wrote a
     Data_intf.All_data.t, and data.bin is regenerated on every build. *)
  let ba = get_blob_raw () in
  let len = Bigarray.Array1.dim ba in
  let b = Bytes.create len in
  for i = 0 to len - 1 do
    Bytes.unsafe_set b i (Bigarray.Array1.unsafe_get ba i)
  done;
  (Marshal.from_bytes b 0 : Data_intf.All_data.t)

module Academic_institution = struct
  include Data_intf.Academic_institution

  let all = data.academic_institutions

  let featured =
    all
    |> List.filter (fun institution ->
           match institution.featured with Some true -> true | _ -> false)

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Academic_testimonial = struct
  include Data_intf.Academic_testimonial

  let all = data.academic_testimonials
end

module Book = struct
  include Data_intf.Book

  let all = data.books
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Changelog = struct
  include Data_intf.Changelog

  let all = data.changelog
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Code_example = struct
  include Data_intf.Code_examples

  let all = data.code_examples
  let get title = List.find (fun x -> String.equal x.title title) all
end

module Event = struct
  include Data_intf.Event

  let all = data.events
  let recurring_event_all = data.recurring_events

  module RecurringEvent = struct
    type t = recurring_event

    let all = recurring_event_all

    let get_by_slug slug =
      List.find_opt (fun (x : t) -> String.equal slug x.slug) all
  end

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Exercise = struct
  include Data_intf.Exercise

  let all = data.exercises

  let filter_tag ?tag =
    let f x =
      Option.fold ~none:(x.tags = []) ~some:(Fun.flip List.mem x.tags) tag
    in
    List.filter f

  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Governance = struct
  include Data_intf.Governance

  let teams = data.governance_teams
  let working_groups = data.governance_working_groups

  let get_by_id id =
    List.find_opt (fun x -> String.equal id x.id) (teams @ working_groups)
end

module Industrial_user = struct
  include Data_intf.Industrial_user

  let all = data.industrial_users
  let featured = all |> List.filter (fun user -> user.featured)
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Job = struct
  include Data_intf.Job

  let all = data.jobs
end

module Testimonial = struct
  include Data_intf.Testimonial

  let all = data.testimonials
end

module News = struct
  include Data_intf.News

  let all = data.news
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Opam_user = struct
  include Data_intf.Opam_user

  let all = data.opam_users

  let make ~name ?email ?github_username ?avatar () =
    { name; email; github_username; avatar }

  let find_by_name s =
    let pattern = String.lowercase_ascii s in
    let contains s1 s2 =
      try
        let len = String.length s2 in
        for i = 0 to String.length s1 - len do
          if String.sub s1 i len = s2 then raise Exit
        done;
        false
      with Exit -> true
    in
    all
    |> List.find_opt (fun { name; _ } ->
           contains pattern (String.lowercase_ascii name))
end

module Page = struct
  include Data_intf.Page

  let all = data.pages

  let get path =
    let slug = Filename.basename path in
    List.find (fun x -> String.equal slug x.slug) all
end

module Paper = struct
  include Data_intf.Paper

  let all = data.papers
  let featured = all |> List.filter (fun paper -> paper.featured)
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Planet = struct
  include Data_intf.Planet

  let all = data.planet
end

module Release = struct
  include Data_intf.Release

  let all = data.releases
  let latest = data.release_latest
  let latest_prerelease = data.release_latest_prerelease
  let latest_platform = data.release_latest_platform
  let lts = data.release_lts

  let get_by_version version =
    if version = "lts" then Some lts
    else if version = "latest" then Some latest
    else
      match
        List.filter (fun x -> String.starts_with ~prefix:version x.version) all
      with
      | [] -> None
      | [ release ] -> Some release
      | u :: v ->
          let int_of_version_tail s =
            match s with
            | None -> 0
            | Some "rc1" -> -1
            | Some "beta1" -> -2
            | _ -> min_int
          in
          let version r =
            let version, tail =
              r.version |> String.split_on_char '+' |> function
              | [ s ] -> (s, None)
              | hd :: [ tl ] -> (hd, Some tl)
              | _ -> failwith ("Unparsable version " ^ r.version)
            in
            let version =
              version |> String.split_on_char '.' |> List.map int_of_string
            in
            version @ [ int_of_version_tail tail ]
          in
          Some
            (List.fold_left
               (fun r1 r2 -> if version r1 > version r2 then r1 else r2)
               u v)
end

module Resource = struct
  include Data_intf.Resource

  let all = data.resources
  let featured = data.featured_resources
end

module Success_story = struct
  include Data_intf.Success_story

  let all = data.success_stories
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tool = struct
  include Data_intf.Tool

  let all = data.tools
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Consortium_page = struct
  include Data_intf.Consortium_page

  let all = data.consortium_pages
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tool_page = struct
  include Data_intf.Tool_page

  let all = data.tool_pages
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end

module Tutorial = struct
  include Data_intf.Tutorial

  let all = data.tutorials
  let all_search_documents = data.tutorial_search_documents
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all

  let search_documents q =
    let score_document (doc : search_document) =
      let regexp =
        Str.global_replace (Str.regexp "[ \t]+") "\\|" (String.trim q)
        |> Str.regexp_case_fold
      in
      let search_in_field field weight =
        match Str.split regexp field with
        | [] -> 0.0
        | matches -> Float.log (float_of_int (List.length matches)) *. weight
      in
      search_in_field doc.title 1.2
      +. search_in_field
           (doc.section
           |> Option.map (fun (s : search_document_section) -> s.title)
           |> Option.value ~default:"")
           2.0
      +. search_in_field doc.content 1.0
    in
    List.filter_map
      (fun doc ->
        let score = score_document doc in
        if score > 0.0 then Some (doc, score) else None)
      all_search_documents
    |> List.sort (fun (_, score1) (_, score2) -> Float.compare score2 score1)
    |> List.map fst
end

module Roadmap = struct
  include Data_intf.Roadmap

  let roadmap = data.roadmap
end

module Video = struct
  include Data_intf.Video

  let all = data.videos
end

module Conference = struct
  include Data_intf.Conference

  let all = data.conferences
  let get_by_slug slug = List.find_opt (fun x -> String.equal slug x.slug) all
end
