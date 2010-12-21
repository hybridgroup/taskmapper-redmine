$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'ticketmaster'
require 'ticketmaster-redmine'
require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

def fixture_for(name)
  File.read(File.dirname(__FILE__) + '/fixtures/' + name + '.xml')
end
