open Import
open Data_intf.Blog

(* external RSS feeds that we aggregate - they will all be scraped by the
   scrape.yml workflow *)

module Source = struct
  (* [publish_all] and [repair] are only used by the scraper (data-scrape) *)
  type t = {
    id : string;
    name : string;
    url : string;
    publish_all : bool option;
    disabled : bool option;
    repair : bool option;
  }
  [@@deriving yaml]

  type sources = t list [@@deriving yaml]

  let all () : source list =
    let file = "planet-sources.yml" in
    let result =
      let ( let* ) = Result.bind in
      let* yaml = Utils.yaml_file file in
      let* sources =
        sources_of_yaml yaml |> Result.map_error (Utils.where file)
      in
      Ok
        (sources
        |> List.map (fun { id; name; url; disabled; _ } ->
               {
                 id;
                 name;
                 url;
                 description = "";
                 disabled = Option.value ~default:false disabled;
               }))
    in
    result
    |> Result.get_ok ~error:(fun (`Msg msg) ->
           Exn.Decode_error (file ^ ": " ^ msg))
end

module Post = struct
  type source_on_external_post = { name : string; url : string }
  [@@deriving yaml]

  type metadata = {
    title : string;
    description : string option;
    url : string;
    date : string;
    preview_image : string option;
    authors : string list option;
    source : source_on_external_post option;
    ignore : bool option;
  }
  [@@deriving yaml]

  let all_sources = Source.all ()

  let of_metadata ~source ~body_html m : Post.t =
    {
      title = m.title;
      source =
        (match source with
        | Ok s -> s
        | Error (`Msg e) -> (
            match m.source with
            | Some { name; url } ->
                { id = ""; name; url; description = ""; disabled = false }
            | None ->
                failwith
                  (e ^ " and there is no source defined in the markdown file")));
      url = m.url;
      slug = "";
      description = m.description;
      authors = Option.value ~default:[] m.authors;
      date = m.date;
      preview_image = m.preview_image;
      body_html;
    }

  let pp_meta ppf v =
    Fmt.pf ppf {|---
%s---
|}
      (metadata_to_yaml v |> Yaml.to_string
      |> Result.get_ok ~error:(fun (`Msg m) -> Exn.Decode_error m))

  let decode (fpath, (head, body_md)) =
    let metadata =
      metadata_of_yaml head |> Result.map_error (Utils.where fpath)
    in
    let body_html =
      body_md |> Markdown.Content.of_string
      |> Markdown.Content.render ~syntax_highlighting:true
    in
    let source =
      match Str.split (Str.regexp_string "/") fpath with
      | _ :: second :: _ -> (
          match
            List.find_opt (fun (s : source) -> s.id = second) all_sources
          with
          | Some source -> Ok source
          | None -> Error (`Msg ("No source found for: " ^ fpath)))
      | _ ->
          failwith
            ("Trying to determine the source for " ^ fpath
           ^ " but the path is not long enough (should start with \
              planet/SOURCE_NAME/...)")
    in
    metadata
    |> Result.map_error (Utils.where fpath)
    |> Result.map (fun m ->
           (m.ignore = Some true, of_metadata ~source ~body_html m))

  (* Posts marked with [ignore: true] are kept in data/planet so that the
     scraper does not fetch them again, but are not published. *)
  let all () : Post.t list =
    Utils.map_md_files decode "planet/*/*.md"
    |> List.filter_map (fun (ignored, post) ->
           if ignored then None else Some post)
    |> List.sort (fun (a : Post.t) (b : Post.t) -> String.compare b.date a.date)
end
