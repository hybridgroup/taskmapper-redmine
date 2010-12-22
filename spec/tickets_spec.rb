require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Redmine::Ticket" do
  before(:all) do
    headers = {'Authorization' => 'Basic Y29yZWQ6MTIzNDU2', 'Accept' => 'application/xml'}
    @project_id = 'test-repo12'
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
      mock.get '/projects/test-repo12.xml', headers, fixture_for('projects/test-repo12'), 200
    end
  end

  before(:each) do 
    @ticketmaster = TicketMaster.new(:redmine, {:server => 'http://demo.redmine.org/', :username => 'cored', :password => '123456'})
    @project = @ticketmaster.project(@project_id)
    @klass = TicketMaster::Provider::Redmine::Ticket
  end

  it "should be able to load all tickets" do 
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end
end
