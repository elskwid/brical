__DIR__ = File.dirname(__FILE__)
$:.unshift "#{__DIR__}/brical", *Dir["#{__DIR__}/../vendor/**/lib"].to_a

require "rubygems"
require "tzinfo"
require "ri_cal"
require "sinatra/base"
require "open-uri"

# vendored
require "atom"

# event helper object
require "lib/eb_event"

module Brical

  class App < Sinatra::Base

    get '/favicon.ico' do
      # nothing here
    end

    get "/:org.ical" do
      RiCal::PropertyValue::DateTime.default_tzid = 'US/Pacific'      
      cal = RiCal.Calendar do |calendar|
        # calendar.product_id = "cityofremo.com/ical"
        # calendar.custom_property("X-WR-CALNAME;VALUE=TEXT", "City of Remo 2009")
        # calendar.custom_property("X-WR-TIMEZONE;VALUE=TEXT", "US/Pacific")
        feed.entries.each do |entry|
          ev = EbEvent.new(entry)
          calendar.event do
            summary         ev.title
            description     ev.summary
            location        ev.where
            url             ev.links.join(",")
            uid             ev.id
            dtstart         ev.start
            dtend           ev.end
            dtstamp         ev.published if ev.published
            security_class "PUBLIC"
          end
        end
      end
      
      content_type "text/calendar"
      body  cal.export
    end

    # just dump out html so we can see something
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
      url = "http://www.eventbrite.com/atom/organizer_list_events/#{params[:org]}"
      puts "** fetching #{url}"
      @feed ||= Atom::Feed.new(open(url).read)
    end
  end
  
end
