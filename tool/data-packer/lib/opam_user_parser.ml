open Data_intf.Opam_user

let all () = Utils.yaml_sequence_file of_yaml "opam-users.yml"
