(* RSS/Atom feeds generated from data/ *)

let feeds =
  [
    ("changelog", Changelog_parser.ChangelogFeed.create_feed);
    ("events", Event_parser.EventsFeed.create_feed);
    ("news", News_parser.RssFeed.create_feed);
    ("planet", Planet_parser.GlobalFeed.create_feed);
    ("job", Job_parser.JobFeed.create_feed);
  ]
