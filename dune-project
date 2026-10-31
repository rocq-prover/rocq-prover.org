(lang dune 3.15)

(name rocqproverorg)

(documentation "https://rocq-prover.org/")

(source
 (github rocq-prover/rocq-prover.org))

(license ISC)

(authors
 "Thibaut Mattio"
 "Lucas Pluvinage"
 "Patrick Ferris"
 "Ashish Agarwal"
 "Kanishka Azimi"
 "Richard Davison"
 "Jiae Kam"
 "Bastien Sozeau"
 "Matthieu Sozeau"
 "Nicolas Tabareau"
 "Théo Zimmermann")

(maintainers "Matthieu Sozeau" "Nicolas Tabareau" "Théo Zimmermann")

(generate_opam_files true)

(using mdx 0.1)

(package
 (name rocqproverorg)
 (synopsis "Official Rocq Prover website")
 (description
  "This repository contains the server that serves the official Rocq website at https://rocq-prover.org.")
 (depends
  (ocaml
   (>= 4.14.0))
  dune
  ppx_deriving
  cohttp
  cohttp-lwt-unix
  bos
  crunch
  (dream
   (>= 1.0.0~alpha8))
  dream-accept
  dream-encoding
  (graphql
   (>= 0.14.0))
  fpath
  fmt
  logs
  (cmarkit
   (>= 0.2.0))
  opam-format
  (timedesc
   (>= 2.0.0))
  yojson
  lwt
  (hilite
   (>= 0.5.0))
  (river
   (>= 0.6))
  syndic
  (alcotest :with-test)
  (mdx
   (and
    :with-test
    (>= 1.10.0)))
  ; tool/data-packer and tool/data-scrape
  (ppx_deriving_yaml
    (>= 0.4.0))
  ppx_stable
  ezjsonm
  ptime
  (cmdliner
   (>= 1.1.0))
  xmlm
  uri))

(dialect
 (name eml)
 (implementation
  (extension eml)
  (preprocess
   (run
    %{bin:dream_eml}
    %{input-file}
    --workspace %{workspace_root}
    --stdout))))
