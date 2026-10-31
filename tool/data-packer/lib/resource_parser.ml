open Data_intf.Resource

let all () = Utils.yaml_sequence_file of_yaml "resources.yml"

let featured () = all () |> List.filter (fun (r : t) -> r.featured = true)
