__DIR__ = File.dirname(__FILE__)
$:.unshift "#{__DIR__}/brical", *Dir["#{__DIR__}/../vendor/**/lib"].to_a

require "rubygems"
require "icalendar"
require "sinatra/base"
require "open-uri"

# vendored
require "atom"

# event helper object
require "lib/eb_event"

module Brical

  class App < Sinatra::Base

    get "/:org.ical" do
      calendar = Icalendar::Calendar.new
      feed.entries.each do |entry|
        ev = EbEvent.new(entry)
    
        calendar.event do
          summary     ev.title
          description ev.summary
          location    ev.where
          url         ev.links.join(",")
          uid         ev.id
          dtstart     ev.dtstart
          dtend       ev.dtend
          dtstamp     ev.published
          klass       "PUBLIC"
        end
      end

      content_type "text/calendar"
      body         calendar.to_ical
    end

    get "/:org" do
      out = ""
      feed.entries.each do |e|
        ev = EbEvent.new(e)
        out << "<hr>"
        out << ev.to_html
      end
      out
    end
    
    def feed
      @feed ||= Atom::Feed.new(open("http://www.eventbrite.com/atom/organizer_list_events/#{params[:org]}").read)
    end
  end
  
end
