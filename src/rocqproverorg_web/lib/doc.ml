(* Serving of the documentation tree (reference manual, corelib, OCaml API,
   standard library and its manual).

   The tree, checked out from https://github.com/rocq-prover/doc, holds one
   directory per version ([V9.3.0], [v9.3], [master], [V9.3+rc1], ...), each
   with one sub-directory per component. All of them used to be served as-is,
   with nothing telling search engines which copy is the current one, so old
   versions came first in search results.

   This module serves the current release at stable paths ([/refman/...],
   [/stdlib/...], ...) and adds the signals search engines use to pick a
   preferred copy: - every versioned HTML page whose counterpart exists in the
   current release carries a [<link rel="canonical">] pointing at the stable
   path; - development and prerelease builds are served with [X-Robots-Tag:
   noindex]; - the sitemap lists the pages of the current release under the
   stable paths (see [Sitemap]). *)

module Url = Rocqproverorg.Url
module Release = Data.Release

let site = "https://rocq-prover.org"

(* The components of the documentation tree, which are also the stable top-level
   paths at which the current release is served. *)
let components = [ "refman"; "corelib"; "api"; "stdlib"; "refman-stdlib" ]
let is_component c = List.mem c components

(* Directory of the documentation tree holding the current version of a
   component. Rocq components live in the directory of the release tag
   ([V9.3.0]); the standard library is released separately and documented in the
   directory of its minor version ([v9.2]). *)
let latest_dir_of ~rocq ~stdlib component =
  match (component, stdlib) with
  | ("stdlib" | "refman-stdlib"), Some v -> "v" ^ Url.minor v
  | _ -> Url.patch rocq

let latest_dir component =
  latest_dir_of ~rocq:Release.latest.version
    ~stdlib:Release.latest.stdlib_version component

(* Development ([master]) and prerelease ([V9.3+rc1], [V9.4+alpha]) directories,
   which should not be indexed by search engines. *)
let is_prerelease_dir version =
  version = "master" || String.contains version '+'

(* Split a path relative to the documentation root, e.g.
   ["V9.2.0/refman/language/core.html"], into its version, component and
   remainder. *)
let split_doc_path path =
  match String.split_on_char '/' path with
  | version :: component :: (_ :: _ as rest) when is_component component ->
      Some (version, component, String.concat "/" rest)
  | _ -> None

let stable_path component rest = "/" ^ component ^ "/" ^ rest
let is_html path = Filename.check_suffix path ".html"

(* Append [index.html] to a path whose last segment looks like a directory. *)
let index_if_dir path =
  match List.rev path with
  | base :: _ when String.contains base '.' -> path
  | rev -> List.rev ("index.html" :: rev)

let find_substring ~sub s =
  let n = String.length s and m = String.length sub in
  let rec go i =
    if i + m > n then None
    else if String.sub s i m = sub then Some i
    else go (i + 1)
  in
  go 0

let canonical_tag href =
  Printf.sprintf "<link rel=\"canonical\" href=\"%s%s\" />\n" site href

(* Insert a canonical link before the closing head tag. Pages without a head are
   left untouched. *)
let inject_canonical ~href html =
  let at i =
    String.sub html 0 i ^ canonical_tag href
    ^ String.sub html i (String.length html - i)
  in
  match find_substring ~sub:"</head>" html with
  | Some i -> at i
  | None -> (
      match find_substring ~sub:"</HEAD>" html with
      | Some i -> at i
      | None -> html)

let noindex_headers = [ ("X-Robots-Tag", "noindex") ]

(* Respond with the file at [root/path], injecting the canonical link into HTML
   pages when [canonical] is given. *)
let respond_file ?(headers = []) ~root ~canonical path =
  let open Lwt.Syntax in
  let file = Filename.concat root path in
  Lwt.catch
    (fun () ->
      Lwt_io.(with_file ~mode:Input file) (fun channel ->
          let* content = Lwt_io.read channel in
          let content =
            match canonical with
            | Some href when is_html path -> inject_canonical ~href content
            | _ -> content
          in
          Dream.respond ~headers:(headers @ Dream.mime_lookup path) content))
    (fun _exn -> Dream.empty `Not_Found)

(* Loader for [/doc/**]: the whole tree, with canonical links on the pages that
   still exist in the current release and noindex on prereleases. *)
let doc_loader root path request =
  let open Lwt.Syntax in
  match split_doc_path path with
  | None -> Dream.from_filesystem root path request
  | Some (version, component, rest) ->
      if is_prerelease_dir version then (
        if is_html path then
          respond_file ~headers:noindex_headers ~root ~canonical:None path
        else
          let+ response = Dream.from_filesystem root path request in
          List.iter
            (fun (k, v) -> Dream.add_header response k v)
            noindex_headers;
          response)
      else if not (is_html path) then Dream.from_filesystem root path request
      else
        let target =
          List.fold_left Filename.concat root
            [ latest_dir component; component; rest ]
        in
        let* exists = Lwt_unix.file_exists target in
        let canonical =
          if exists then Some (stable_path component rest) else None
        in
        respond_file ~root ~canonical path

(* Loader for the stable paths [/<component>/**], serving the current release of
   [component] with a self-referencing canonical link. *)
let stable_loader component root rest _request =
  let path =
    List.fold_left Filename.concat (latest_dir component) [ component; rest ]
  in
  respond_file ~root ~canonical:(Some (stable_path component rest)) path

(* Paths of the HTML pages of the current release of each component, under the
   stable paths, for the sitemap. *)
let sitemap_urls root =
  let pages component =
    let dir = Fpath.(v root / latest_dir component / component) in
    let add path urls =
      if not (Fpath.has_ext ".html" path) then urls
      else
        match Fpath.relativize ~root:dir path with
        | Some rel -> stable_path component (Fpath.to_string rel) :: urls
        | None -> urls
    in
    match Bos.OS.Path.fold ~elements:`Files add [] [ dir ] with
    | Ok urls -> urls
    | Error (`Msg msg) ->
        Dream.log "sitemap: could not list %s: %s" (Fpath.to_string dir) msg;
        []
  in
  List.concat_map pages components |> List.sort_uniq compare
