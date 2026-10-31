(* Video type shared with the scrapers *)

include Data_intf.Video

type video_list = t list [@@deriving yaml, show]
