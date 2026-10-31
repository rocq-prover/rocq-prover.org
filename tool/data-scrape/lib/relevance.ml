(* Whether scraped content is about Rocq. Used for sources that are not
   published in full ([publish_all: false]). *)

open Data_packer.Import

let keywords = [ "rocq"; "coq" ]

let is_relevant texts =
  List.exists
    (fun text ->
      List.exists (fun k -> String.is_sub_ignore_case k text) keywords)
    texts
