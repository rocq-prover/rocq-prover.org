open Data_intf.Paper

type author_entry = 
  { family : string; given : string }
[@@deriving of_yaml ]
let inline_author { family; given } =
  given ^ " " ^ family
type author_entries = author_entry list
[@@deriving of_yaml]

type author_inline_list = string list
[@@deriving of_yaml]

let parse_authors yaml =
  match author_inline_list_of_yaml yaml with
  | Error _ ->
    (match author_entries_of_yaml yaml with
    | Error e -> Error e
    | Ok l -> Ok (List.map inline_author l))
  | Ok l -> Ok l

type metadata = {
  title : string;
  publication : string option [@default None];
  authors : string list [@default []] [@of_yaml parse_authors];
  author : string list [@default []] [@of_yaml parse_authors];
  editors : string list [@default []] [@of_yaml parse_authors] [@key "editor"];
  abstract : string [@default ""];
  tags : string list [@default []];
  keyword : string option [@default None];
  year : int option [@default None];
  links : link list [@default []];
  featured : bool [@default false];
  container_title : string option [@default None] [@key "container-title"];
  collection_title : string option [@default None] [@key "collection-title"];
  doi: string option [@default None];
  url: string option [@default None];
  id: string option [@default None];
  issue: int option [@default None];
  volume : int option [@default None];
  issued: int option [@default None];
  publisher : string option [@default None];
  page: string option [@default None];
  type_: string option [@default None] [@key "type"];
  note : string option [@default None];
}
[@@deriving of_yaml ~skip_unknown, stable_record ~version:Record.t ~add:[ slug ]]

let of_metadata m = record_to_t (metadata_to_Record_t m ~slug:(Utils.slugify m.title))

let decode s = Result.map of_metadata (metadata_of_yaml s)

let all () =
  Utils.yaml_sequence_file decode "papers.yml"
  |> List.sort (fun (p1 : t) (p2 : t) ->
         (2 * Int.compare p2.year p1.year) + String.compare p1.title p2.title)
