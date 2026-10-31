open Import
open Data_intf.Roadmap

let rec toc_toc (toc : Markdown.Toc.t list) = List.map toc_f toc

and toc_f { title; href; children } =
  { title; href; children = toc_toc children }

let decode (fpath, body_md) =
  let doc = Markdown.Content.of_string body_md in
  let toc = Markdown.Toc.generate ~start_level:1 ~max_level:4 doc in
  let body_html = 
    (* TODO plug in alectryon here *)
     Markdown.Content.render ~syntax_highlighting:true doc in
  { fpath = Fpath.to_string fpath; toc = (toc_toc toc); body_md; body_html }

let roadmap () =
  let fpath = Fpath.v "roadmap/roadmap.md" in
  match Utils.read_file fpath with
  | Some content -> decode (fpath, content)
  | None -> decode (fpath, "roadmap/roadmap.md is absent") (* Silently fails when no roadmap is there *)
