(* data-feed: Generate the RSS/Atom feeds from data/ *)

open Cmdliner

let cmds =
  Cmd.group (Cmd.info "data-feed" ~version:"%%VERSION%%")
  @@ List.map
       (fun (term, create_feed) ->
         Cmd.v (Cmd.info term)
           Term.(const (fun () -> print_endline (create_feed ())) $ const ()))
       Data_packer.Feed.feeds

let () =
  Printexc.record_backtrace true;
  exit (Cmd.eval cmds)
