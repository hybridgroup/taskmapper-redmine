require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ticketmaster::Provider::Redmine::Project" do
  before(:all) do
    headers = {'Authorization' => 'Basic Y29yZWQ6MTIzNDU2', 'Accept' => 'application/xml'}
    headers_post_put = {'Authorization' => 'Basic Y29yZWQ6MTIzNDU2', 'Content-Type' => 'application/xml'}
    @project_id = 'test-repo12'
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
      mock.get '/projects/test-repo12.xml', headers, fixture_for('projects/test-repo12'), 200
      mock.put '/projects/1.xml', headers_post_put, '', 200
      mock.post '/projects.xml', headers_post_put, '', 200
    end
  end

  before(:each) do 
    @ticketmaster = TicketMaster.new(:redmine, {:server => 'http://demo.redmine.org/', :username => 'cored', :password => '123456'})
    @klass = TicketMaster::Provider::Redmine::Project
  end

  it "should be able to load all projects" do 
    @ticketmaster.projects.should be_an_instance_of(Array)
    @ticketmaster.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load projects from an array of id's" do 
    @projects = @ticketmaster.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.identifier.should == @project_id
  end

  it "should be able to load all projects from attributes" do 
    @projects = @ticketmaster.projects(:identifier => 'redmine')
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.identifier.should == 'redmine'
  end

  it "should be able to find a project" do 
    @ticketmaster.project.should == @klass
    @ticketmaster.project.find(@project_id).should be_an_instance_of(@klass)
  end

  it "should be able to find a project by identifier" do 
    @ticketmaster.project(@project_id).should be_an_instance_of(@klass)
    @ticketmaster.project(@project_id).identifier.should == @project_id
  end

  it "should be able to update and save a project" do
    @project = @ticketmaster.project(@project_id)
    @project.update!(:name => 'named').should == true
  end

  it "should be able to create a new project" do 
    @project = @ticketmaster.project!(:name => 'newtest', :identifier => 'dumb', :description => 'hithere').should be_an_instance_of(@klass)
  end
end
