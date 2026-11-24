module Doc = Rocqproverorg_web.Doc

let check_string = Alcotest.(check string)
let check_bool = Alcotest.(check bool)

let latest_dir () =
  let latest = Doc.latest_dir_of ~rocq:"9.3.0" ~stdlib:(Some "9.2.0") in
  check_string "refman" "V9.3.0" (latest "refman");
  check_string "corelib" "V9.3.0" (latest "corelib");
  check_string "api" "V9.3.0" (latest "api");
  check_string "stdlib" "v9.2" (latest "stdlib");
  check_string "refman-stdlib" "v9.2" (latest "refman-stdlib");
  check_string "stdlib before the split" "V8.20.1"
    (Doc.latest_dir_of ~rocq:"8.20.1" ~stdlib:None "stdlib")

let prerelease_dir () =
  check_bool "master" true (Doc.is_prerelease_dir "master");
  check_bool "rc" true (Doc.is_prerelease_dir "V9.3+rc1");
  check_bool "alpha" true (Doc.is_prerelease_dir "V9.4+alpha");
  check_bool "release" false (Doc.is_prerelease_dir "V9.3.0");
  check_bool "branch" false (Doc.is_prerelease_dir "v9.3")

let split_doc_path () =
  let check msg expected path =
    Alcotest.(check (option (triple string string string)))
      msg expected (Doc.split_doc_path path)
  in
  check "refman page"
    (Some ("V9.2.0", "refman", "language/core/sections.html"))
    "V9.2.0/refman/language/core/sections.html";
  check "stdlib page"
    (Some ("v9.2", "refman-stdlib", "index.html"))
    "v9.2/refman-stdlib/index.html";
  check "unknown component" None "V8.0/doc/index.html";
  check "component directory only" None "V9.2.0/refman";
  check "version only" None "V9.2.0"

let index_if_dir () =
  let check msg expected path =
    Alcotest.(check (list string)) msg expected (Doc.index_if_dir path)
  in
  check "directory" [ "refman"; "index.html" ] [ "refman" ];
  check "nested directory"
    [ "refman"; "language"; "index.html" ]
    [ "refman"; "language" ];
  check "file" [ "refman"; "index.html" ] [ "refman"; "index.html" ];
  check "other file"
    [ "refman"; "_static"; "theme.css" ]
    [ "refman"; "_static"; "theme.css" ]

let inject_canonical () =
  let page = "<html><head><title>T</title></head><body></body></html>" in
  check_string "canonical before </head>"
    "<html><head><title>T</title><link rel=\"canonical\" \
     href=\"https://rocq-prover.org/refman/x.html\" />\n\
     </head><body></body></html>"
    (Doc.inject_canonical ~href:"/refman/x.html" page);
  check_string "no head" "<p>x</p>"
    (Doc.inject_canonical ~href:"/refman/x.html" "<p>x</p>")

(* Directories of a small documentation tree: the current Rocq release and
   standard library as given by the site data, an old release, a prerelease and
   a version with an unknown layout. *)
let current = Doc.latest_dir "refman"
let current_stdlib = Doc.latest_dir "refman-stdlib"
let old = "V0.1.0"
let prerelease = "V99.0+alpha"
let unknown = "V0.0"

let with_doc_tree f =
  assert (old <> current && prerelease <> current && unknown <> current);
  let root = Filename.temp_file "rocq-doc" "" in
  Sys.remove root;
  let write path content =
    let file = Filename.concat root path in
    let rec mkdir d =
      if not (Sys.file_exists d) then (
        mkdir (Filename.dirname d);
        Sys.mkdir d 0o755)
    in
    mkdir (Filename.dirname file);
    Out_channel.with_open_bin file (fun oc -> output_string oc content)
  in
  let html title = "<html><head><title>" ^ title ^ "</title></head></html>" in
  write (current ^ "/refman/index.html") (html "current");
  write (current ^ "/refman/new.html") (html "current new");
  write (current ^ "/refman/_static/theme.css") "body {}";
  write (old ^ "/refman/index.html") (html "old");
  write (old ^ "/refman/removed.html") (html "old removed");
  write (prerelease ^ "/refman/index.html") (html "prerelease");
  write "master/refman/_static/theme.css" "body {}";
  write (current_stdlib ^ "/refman-stdlib/index.html") (html "current stdlib");
  write (unknown ^ "/doc/index.html") (html "unknown layout");
  f root

let run handler = Dream.test handler (Dream.request ~target:"/" "")
let body response = Lwt_main.run (Dream.body response)
let status response = Dream.status_to_int (Dream.status response)
let contains sub response = Doc.find_substring ~sub (body response) <> None
let has_canonical href = contains (Doc.canonical_tag href)
let robots response = Dream.header response "X-Robots-Tag"

let doc_loader () =
  with_doc_tree @@ fun root ->
  let get path = run (Doc.doc_loader root path) in
  let r = get (old ^ "/refman/index.html") in
  Alcotest.(check int) "old page status" 200 (status r);
  check_bool "old page canonical" true (has_canonical "/refman/index.html" r);
  Alcotest.(check (option string)) "old page indexable" None (robots r);
  let r = get (old ^ "/refman/removed.html") in
  check_bool "removed page has no canonical" false (contains "canonical" r);
  let r = get (current ^ "/refman/new.html") in
  check_bool "current page canonical" true (has_canonical "/refman/new.html" r);
  let r = get (current ^ "/refman/_static/theme.css") in
  check_string "asset untouched" "body {}" (body r);
  let r = get (prerelease ^ "/refman/index.html") in
  Alcotest.(check (option string))
    "prerelease noindex" (Some "noindex") (robots r);
  check_bool "prerelease has no canonical" false (contains "canonical" r);
  let r = get "master/refman/_static/theme.css" in
  Alcotest.(check (option string))
    "prerelease asset noindex" (Some "noindex") (robots r);
  let r = get (current_stdlib ^ "/refman-stdlib/index.html") in
  check_bool "stdlib canonical" true
    (has_canonical "/refman-stdlib/index.html" r);
  let r = get (unknown ^ "/doc/index.html") in
  Alcotest.(check int) "unknown layout served" 200 (status r);
  check_bool "unknown layout untouched" false (contains "canonical" r);
  let r = get (old ^ "/refman/missing.html") in
  Alcotest.(check int) "missing page" 404 (status r)

let stable_loader () =
  with_doc_tree @@ fun root ->
  let get component rest = run (Doc.stable_loader component root rest) in
  let r = get "refman" "new.html" in
  Alcotest.(check int) "current page status" 200 (status r);
  check_bool "serves current release" true (contains "current new" r);
  check_bool "self canonical" true (has_canonical "/refman/new.html" r);
  let r = get "refman-stdlib" "index.html" in
  check_bool "stdlib from its own directory" true (contains "current stdlib" r);
  let r = get "refman" "removed.html" in
  Alcotest.(check int) "page absent from current release" 404 (status r)

let sitemap_urls () =
  with_doc_tree @@ fun root ->
  Alcotest.(check (list string))
    "html pages of the current release"
    [ "/refman-stdlib/index.html"; "/refman/index.html"; "/refman/new.html" ]
    (Doc.sitemap_urls root)

let () =
  Alcotest.run "doc"
    [
      ( "paths",
        [
          Alcotest.test_case "latest_dir" `Quick latest_dir;
          Alcotest.test_case "is_prerelease_dir" `Quick prerelease_dir;
          Alcotest.test_case "split_doc_path" `Quick split_doc_path;
          Alcotest.test_case "index_if_dir" `Quick index_if_dir;
          Alcotest.test_case "inject_canonical" `Quick inject_canonical;
        ] );
      ( "serving",
        [
          Alcotest.test_case "doc_loader" `Quick doc_loader;
          Alcotest.test_case "stable_loader" `Quick stable_loader;
          Alcotest.test_case "sitemap_urls" `Quick sitemap_urls;
        ] );
    ]
