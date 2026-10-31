(* The main packing logic *)

(* Serialised with Marshal: the packer (writer) and the server (reader) are
   always built together by the same compiler, and data.bin is regenerated on
   every build. *)
let pack_to_buffer (data : Data_intf.All_data.t) = Marshal.to_bytes data []

let pack_to_file ~output data =
  let buf = pack_to_buffer data in
  let oc = open_out_bin output in
  output_bytes oc buf;
  close_out oc;
  Printf.eprintf "Packed %d bytes to %s\n" (Bytes.length buf) output

let load_all () : Data_intf.All_data.t =
  let ( release_latest,
        release_latest_prerelease,
        release_latest_stdlib,
        release_latest_platform,
        release_lts ) =
    Release_parser.selected ()
  in
  {
    academic_institutions = Academic_institution_parser.all ();
    academic_testimonials = Academic_testimonial_parser.all ();
    books = Book_parser.all ();
    changelog = Changelog_parser.all ();
    code_examples = Code_example_parser.all ();
    conferences = Conference_parser.all ();
    consortium_pages = Consortium_page_parser.all ();
    events = Event_parser.all ();
    recurring_events = Event_parser.recurring_event_all ();
    exercises = Exercise_parser.all ();
    governance_teams = Governance_parser.all_teams ();
    governance_working_groups = Governance_parser.working_groups ();
    industrial_users = Industrial_user_parser.all ();
    jobs = Job_parser.all ();
    news = News_parser.all ();
    opam_users = Opam_user_parser.all ();
    pages = Page_parser.all ();
    papers = Paper_parser.all ();
    planet = Planet_parser.all ();
    releases = Release_parser.all ();
    release_latest;
    release_latest_prerelease;
    release_latest_stdlib;
    release_latest_platform;
    release_lts;
    resources = Resource_parser.all ();
    featured_resources = Resource_parser.featured ();
    roadmap = Roadmap_parser.roadmap ();
    success_stories = Success_story_parser.all ();
    testimonials = Testimonial_parser.all ();
    tools = Tool_parser.all ();
    tool_pages = Tool_page_parser.all ();
    tutorials = Tutorial_parser.all ();
    tutorial_search_documents = Tutorial_parser.TutorialSearch.all ();
    videos = Video_parser.all ();
  }
