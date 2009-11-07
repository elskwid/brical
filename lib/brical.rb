__DIR__ = File.dirname(__FILE__)
$:.unshift "#{__DIR__}/brical", *Dir["#{__DIR__}/../vendor/**/lib"].to_a

require "rubygems"
require "icalendar"

require "open-uri"

# vendored
require "atom"
require "sinatra/base"

module Brical

  class App < Sinatra::Base
    get "/:org.ical" do
      calendar = Icalendar::Calendar.new
      feed.entries.each do |entry|
        
        puts entry.inspect
        
        calendar.event do
          dtstamp entry.published
          dtstart entry.published
          dtend   entry.published

          summary     entry.title.to_s
          description entry.content.to_s
          uid         entry.id
          klass       "PUBLIC"
        end
      end

      content_type "text/calendar"
      body         calendar.to_ical
    end

    def feed
      @feed ||= Atom::Feed.new(open("http://www.eventbrite.com/atom/organizer_list_events/#{params[:org]}").read)
    end
  end
end
