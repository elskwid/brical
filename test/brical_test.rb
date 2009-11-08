require File.dirname(__FILE__) + "/test_helper"

class BricalTest < Test::Unit::TestCase
  
  def app
    Brical::App
  end
  
  def test_it_responds_to_request
    get "/#{org_id}"
    assert last_response.ok?
  end
  
  def test_it_returns_events_html
    get "/#{org_id}"
    assert last_response.body.include?("tag:eventbrite.com:event-483716810")
  end
  
  def test_it_returns_events_ical
    get "/#{org_id}.ical"
    assert  last_response.ok?
    assert_equal "text/calendar", last_response["Content-Type"]
    assert last_response.body.include?("UID:tag:eventbrite.com:event-483716810")
    assert last_response.body =~ /VCALENDAR/
  end

end
