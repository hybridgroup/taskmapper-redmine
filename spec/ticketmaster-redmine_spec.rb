require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Redmine" do
  
  it "should be able to instantiate a new instance" do
    @ticketmaster = TicketMaster.new(:redmine, {:server => 'http://redmine.server', :username => 'cored', :password => 'afdd'})
    @ticketmaster.should be_an_instance_of(TicketMaster)
    @ticketmaster.should be_a_kind_of(TicketMaster::Provider::Redmine)
  end
  
end
