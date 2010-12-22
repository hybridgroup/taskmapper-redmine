require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Redmine::Ticket" do
  before(:all) do
    headers = {'Authorization' => 'Basic Y29yZWQ6MTIzNDU2', 'Accept' => 'application/xml'}
    @project_id = 'test-repo12'
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
      mock.get '/projects/test-repo12.xml', headers, fixture_for('projects/test-repo12'), 200
      mock.get '/issues.xml', headers, fixture_for('issues'), 200
      mock.get '/issues/4326.xml', headers, fixture_for('issues/4326'), 200
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

  it "should be able to load all tickets based on an array of id's" do
    @tickets = @project.tickets([4326])
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == 4326
  end

  it "should be able to load all tickets based on attributes" do
    @tickets = @project.tickets(:id => 4326)
    @tickets.should be_an_instance_of(Array)
    @tickets.first.should be_an_instance_of(@klass)
    @tickets.first.id.should == 4326
  end

  it "should return the ticket class" do
    @project.ticket.should == @klass
  end

  it "should be able to load a single ticket" do
    @ticket = @project.ticket(4326)
    @ticket.should be_an_instance_of(@klass)
    @ticket.id.should == 4326
  end

  it "shoule be able to load a single ticket based on attributes" do
    @ticket = @project.ticket(:id => 4326)
    @ticket.should be_an_instance_of(@klass)
    @ticket.id.should == 4326
  end

end
