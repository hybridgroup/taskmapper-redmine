$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'ticketmaster'
require 'ticketmaster-redmine'
require 'rspec'

RSpec.configure do |config|
  config.color_enabled = true
end

def fixture_for(name)
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + '.xml')
end
