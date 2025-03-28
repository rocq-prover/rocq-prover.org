open Rocqproverorg

let make ?(permanent = false) t =
  let status = if permanent then `Moved_Permanently else `See_Other in
  Dream.scope ""
    [ Dream_encoding.compress ]
    (List.filter_map
       (fun (origin, new_) ->
         if origin = new_ then None
         else
           Some (Dream.get origin (fun req -> Dream.redirect ~status req new_)))
       t)

let package req =
  let package = Dream.param req "name" in
  Dream.redirect req (Url.Package.overview package)

let package_docs req =
  let package = Dream.param req "name" in
  Dream.redirect req (Url.Package.documentation package)

let opam_www req =
  Dream.(redirect ~status:`Moved_Permanently req "/packages")

let opam req =
  Dream.(redirect ~status:`Found req ("https://rocq-prover.github.io" ^ target req))

let http_or_404 ?(not_found = Rocqproverorg_frontend.not_found) opt f =
  Option.fold ~none:(Dream.html ~code:404 (not_found ())) ~some:f opt

let distrib req =
  let target = Dream.target req in
  let path = String.split_on_char '/' target in
  let newurl = match path with
  | "" :: "distrib" :: version :: component :: tail ->
    (match version with 
    | "current" -> 
      (match component with
      | "refman" -> Some ("/refman/" ^ String.concat "/" tail)
      | "stdlib" -> Some ("/stdlib/" ^ String.concat "/" tail)
      | _ ->  None)
    | version -> 
      (match component with
      | "refman" -> Some ("/doc/" ^ version ^ "/refman/" ^ String.concat "/" tail)
      | "stdlib" -> Some ("/doc/" ^ version ^ "/stdlib/" ^ String.concat "/" tail)
      | _ ->  None))
  | "" :: "library" :: tail -> Some ("/stdlib/" ^ String.concat "/" tail)
  | _ -> None
  in
  http_or_404 newurl Dream.(redirect ~status:`Found req)

let old_sites_modules req =
  Dream.(redirect ~status:`Found req ("https://rocq-prover.github.io" ^ target req))

let documentation req =
  Dream.(redirect ~status:`Moved_Permanently req "/docs")
  
let opam_packaging req =
  Dream.(redirect ~status:`Found req ("https://rocq-prover.github.io" ^ target req))
  
let platform_docs req =
  Dream.(redirect ~status:`Found req ("https://rocq-prover.github.io" ^ target req))

let cocorico req =
  let target = Dream.target req in
  let path = String.split_on_char '/' target in
  match path with
  | "" :: "cocorico" :: tail ->
    Dream.(redirect ~status:`Moved_Permanently req ("https://github.com/rocq-prover/rocq/wiki/" ^ String.concat "/" tail))
  | _ -> Dream.html ~code:404 (Rocqproverorg_frontend.not_found ())

let bugs req =
  let target = Dream.target req in
  let path = String.split_on_char '/' target in
  match path with
  | "" :: ("bugs" | "bug") :: tail ->
    if List.length tail = 1 && String.starts_with ~prefix:"show_bug.cgi?id=" (List.hd tail) then
      Dream.redirect ~status:`Moved_Permanently req ("https://github.com/rocq-prover/rocq/issues/" ^ (String.sub (List.hd tail) 16 (String.length (List.hd tail) - 16)))
    else
      Dream.(redirect ~status:`Moved_Permanently req ("https://github.com/rocq-prover/rocq/issues/" ^ String.concat "/" tail))
  | _ -> Dream.html ~code:404 (Rocqproverorg_frontend.not_found ())

let t =
  Dream.scope "" []
    ([
       make ~permanent:true [ ("roadmap.html", "/roadmap") ];
       make ~permanent:true [ ("favicon.ico"), "/logos/favicon.ico"];
       Dream.get "/p/:name" package;
       Dream.get "/u/:hash/p/:name" package;
       Dream.get "/p/:name/doc" package_docs;
       Dream.get "/opam/www" opam_www;
       Dream.get "/opam/www/**" opam_www;
       Dream.get "/coq-package-index" opam_www;
       Dream.get "/opam/**" opam;
       Dream.get "/distrib/**" distrib;
       Dream.get "/library" distrib;
       Dream.get "/library/**" distrib;
       Dream.get "/sites/**" old_sites_modules;
       Dream.get "/modules/**" old_sites_modules;
       Dream.get "/documentation" documentation;
       Dream.get "/doc" documentation;
       Dream.get "/opam-packaging.html" opam_packaging;
       Dream.get "/opam-packaging" opam_packaging;
       Dream.get "/platform-docs/**" platform_docs;
       Dream.get "/cocorico" cocorico;
       Dream.get "/cocorico.html" cocorico;
       Dream.get "/cocorico/**" cocorico;
       Dream.get "/bugs" bugs;
       Dream.get "/bugs/**" bugs;
       Dream.get "/bug" bugs;
       Dream.get "/bug/**" bugs;
       make ~permanent:true [ "/platform-docs", "/docs/platform-docs" ] ;
       make ~permanent:true [ "/docs/installing-rocq", "/docs/using-opam" ] ;
       make ~permanent:true [ "/opam-using.html", "/docs/using-opam" ] ;
       make ~permanent:true [ "/user-interfaces.html", "/install" ] ;
       make ~permanent:true [ "/about-coq", "/about" ] ;
       make ~permanent:true [ "/about-coq.html", "/about" ] ;
       make ~permanent:true [ "/community.html", "/community" ] ;
       make ~permanent:true [ "/coq-team.html", "/rocq-team" ] ;
       make ~permanent:true [ "/download", "/install" ] ;
       make ~permanent:true [ "/download.html", "/install" ] ;
       make ~permanent:true [ "/related-tools", "https://github.com/rocq-community/awesome-coq?tab=readme-ov-file#tools" ];
       make ~permanent:true [ "/related-tools.html", "https://github.com/rocq-community/awesome-coq?tab=readme-ov-file#tools" ];
       make ~permanent:true [ "/faq", "https://github.com/rocq-prover/rocq/wiki/The-Rocq-FAQ" ];
       make ~permanent:true [ "/faq.html", "https://github.com/rocq-prover/rocq/wiki/The-Rocq-FAQ" ];
       make ~permanent:true [ "/a-short-introduction-to-coq", "/docs/tour-of-rocq" ] ;
       make ~permanent:false [ "/nix/math-comp", "https://github.com/math-comp/math-comp-nix/archive/v2.tar.gz" ] ;
       make ~permanent:false [ "/nix/toolbox", "https://github.com/rocq-community/coq-nix-toolbox/archive/master.tar.gz" ] ;
     ])
