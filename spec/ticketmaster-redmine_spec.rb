require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Redmine" do

  before :each do 
    headers = {'Authorization' => 'Basic Y29yZWQ6YWZkZA==', 'Accept' => 'application/xml'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
    end
  end

  it "should be able to instantiate a new instance" do
    ticketmaster = TicketMaster.new(:redmine, :server => 'http://redmine.server', :token => 'kdkjkladkaldj')
    ticketmaster.should be_an_instance_of(TicketMaster)
    ticketmaster.should be_a_kind_of(TicketMaster::Provider::Redmine)
  end

end
