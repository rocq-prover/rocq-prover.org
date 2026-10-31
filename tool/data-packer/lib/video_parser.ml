open Import
open Data_intf.Video

type video_list = t list [@@deriving of_yaml]

let load_video_file file : t list =
  let ( let* ) = Result.bind in
  let result =
    let* yaml = Utils.yaml_file file in
    video_list_of_yaml yaml |> Result.map_error (Utils.where file)
  in
  result |> Result.get_ok ~error:(fun (`Msg msg) -> Exn.Decode_error msg)

let all () : t list = load_video_file "video-youtube.yml"
