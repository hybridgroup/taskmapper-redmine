require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Redmine::Ticket" do
  before(:each) do 
    headers = {'X-Redmine-API-Key' => 'abcdefghijk', 'Accept' => 'application/xml'}
    headers_post_put = {'X-Redmine-API-Key' => 'abcdefghijk', 'Content-Type' => 'application/xml'}
    @project_id = 1
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
      mock.get '/projects/1.xml', headers, fixture_for('projects/test-repo12'), 200
      mock.get '/issues.xml?project_id=1', headers, fixture_for('issues'), 200
      mock.get '/issues.xml', headers, fixture_for('issues'), 200
      mock.get '/issues/1.xml', headers, fixture_for('issues/1'), 200
      mock.put '/issues/1.xml', headers_post_put, '', 200
      mock.post '/issues.xml', headers_post_put, '', 200
    end
  
    @ticketmaster = TicketMaster.new :redmine, :server => 'http://demo.redmine.org/', :token => 'abcdefghijk'
    @project = @ticketmaster.project(@project_id)
    @klass = TicketMaster::Provider::Redmine::Ticket
  end

  it "should be able to load all tickets" do 
    @project.tickets.should be_an_instance_of(Array)
    @project.tickets.first.should be_an_instance_of(@klass)
  end

  it "should be able to load all tickets based on an array of id's" do
    @tickets = @project.tickets([1])
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.title.should == 'test-issue'
  end

  it "should be able to load all tickets based on attributes" do
    @tickets = @project.tickets(:id => 1)
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.title.should == 'test-issue'
  end

  it "should return the ticket class" do
    @project.ticket.should == @klass
  end

  it "should be able to load a single ticket" do
    @ticket = @project.ticket(1)
    @ticket.should be_an_instance_of(@klass)
    @ticket.title.should == 'test-issue'
  end

  it "should be able to update and save a ticket" do
    @ticket = @project.ticket(1)
    @ticket.description = 'hello'
    @ticket.save.should == true
  end

  it "should be able to create a ticket" do 
    @ticket = @project.ticket!(:title => 'Ticket #12', :description => 'Body')
    @ticket.should be_an_instance_of(@klass)
    @ticket.project_id.should_not be_nil
  end

end
