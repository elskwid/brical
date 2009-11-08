require File.dirname(__FILE__) + "/test_helper"

class EbEventTest < Test::Unit::TestCase

  def feed
    Atom::Feed.new(atom_feed)
  end
  
  def entry
    Brical::EbEvent.new(feed.entries.first)
  end
  
  def test_feed_is_loaded
    assert_equal 7, feed.entries.length
  end

  def test_html_is_present_in_raw_content
    assert_match(/<b>/, entry.raw_content)
  end
  
  def test_html_is_stripped_from_content
    assert_no_match(/<b>/, entry.stripped_content)
  end
  
  def test_id
    assert_equal "tag:eventbrite.com:event-483716810", entry.id
  end
  
  # for some reason we don't get a published date from eventbrite
  def test_published
    assert_nil entry.published
  end
  
  def test_title
    assert_equal "Cinemo Remo", entry.title
  end
  
  def test_when
    assert_equal "Wednesday, November 11, 2009 from 8:00 PM - 10:00 PM (PT)", entry.when
  end
  
  def test_where
    assert_equal "Biggest Little City Club\n188 California Avenue\nReno, NV", entry.where
  end

  def test_summary
    assert_match(/Come support Men's Health awareness/, entry.summary)
  end
  
  def test_start
    assert_equal "2009-11-11T20:00:00+00:00", entry.start.to_s
  end
  
  def test_end
    assert_equal "2009-11-11T22:00:00+00:00", entry.end.to_s
  end
end
