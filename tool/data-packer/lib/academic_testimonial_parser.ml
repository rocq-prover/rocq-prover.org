open Data_intf.Academic_testimonial

let all () = Utils.yaml_sequence_file of_yaml "academic-testimonials.yml"
