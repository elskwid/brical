require File.dirname(__FILE__) + "/../lib/brical"
require File.dirname(__FILE__) + "/../lib/eb_event"

require "test/unit"
require "rack/test"

module TestHelper
  def org_id
    "339849409"
  end
  
  def atom_feed
    File.read(File.dirname(__FILE__) + "/fixtures/#{org_id}.atom")
  end
end

class Test::Unit::TestCase
  include TestHelper
  include Rack::Test::Methods
end

class Brical::App
  include TestHelper
  
  def feed
    Atom::Feed.new(atom_feed)
  end
end
