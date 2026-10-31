open Data_intf.Testimonial

let all () = Utils.yaml_sequence_file of_yaml "testimonials.yml"
