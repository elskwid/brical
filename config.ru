require 'lib/brical'

use Rack::ShowExceptions

run Brical::App.new