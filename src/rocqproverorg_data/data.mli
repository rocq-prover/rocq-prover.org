module Academic_institution : sig
  include module type of Data_intf.Academic_institution

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Academic_testimonial : sig
  include module type of Data_intf.Academic_testimonial

  val all : t list
end

module Book : sig
  include module type of Data_intf.Book

  val all : t list
  val get_by_slug : string -> t option
end

module Changelog : sig
  include module type of Data_intf.Changelog

  val all : t list
  val get_by_slug : string -> t option
end

module Code_example : sig
  type t = { title : string; body : string }

  val get : string -> t
end

module Event : sig
  include module type of Data_intf.Event

  module RecurringEvent : sig
    type t = recurring_event

    val all : t list
    val get_by_slug : string -> t option
  end

  val all : t list
  val get_by_slug : string -> t option
end

module Exercise : sig
  include module type of Data_intf.Exercise

  val all : t list
  val filter_tag : ?tag:string -> t list -> t list
  val get_by_slug : string -> t option
end

module Governance : sig
  include module type of Data_intf.Governance

  val teams : team list
  val working_groups : team list
  val get_by_id : string -> team option
end

module Industrial_user : sig
  include module type of Data_intf.Industrial_user

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Job : sig
  include module type of Data_intf.Job

  val all : t list
end

module Testimonial : sig
  include module type of Data_intf.Testimonial

  val all : t list
end

module News : sig
  include module type of Data_intf.News

  val all : t list
  val get_by_slug : string -> t option
end

module Opam_user : sig
  include module type of Data_intf.Opam_user

  val all : t list

  val make :
    name:string ->
    ?email:string ->
    ?github_username:string ->
    ?avatar:string ->
    unit ->
    t

  val find_by_name : string -> t option
end

module Page : sig
  include module type of Data_intf.Page

  val get : string -> t
end

module Paper : sig
  include module type of Data_intf.Paper

  val all : t list
  val featured : t list
  val get_by_slug : string -> t option
end

module Planet : sig
  include module type of Data_intf.Planet

  val all : entry list
end

module Release : sig
  include module type of Data_intf.Release

  val all : t list
  val get_by_version : string -> t option
  val latest : t
  val latest_prerelease : t option
  val latest_platform : t
  val lts : t
end

module Resource : sig
  include module type of Data_intf.Resource

  val all : t list
  val featured : t list
end

module Success_story : sig
  include module type of Data_intf.Success_story

  val all : t list
  val get_by_slug : string -> t option
end

module Tool : sig
  include module type of Data_intf.Tool

  val all : t list
  val get_by_slug : string -> t option
end

module Consortium_page : sig
  include module type of Data_intf.Consortium_page

  val all : t list
  val get_by_slug : string -> t option
end

module Tool_page : sig
  include module type of Data_intf.Tool_page

  val all : t list
  val get_by_slug : string -> t option
end

module Tutorial : sig
  include module type of Data_intf.Tutorial

  val all : t list
  val all_search_documents : search_document list
  val get_by_slug : string -> t option
  val search_documents : string -> search_document list
end

module Roadmap : sig
  include module type of Data_intf.Roadmap

  val roadmap : t
end
module Video : sig
  include module type of Data_intf.Video

  val all : t list
end

module Conference : sig
  include module type of Data_intf.Conference

  val all : t list
  val get_by_slug : string -> t option
end
