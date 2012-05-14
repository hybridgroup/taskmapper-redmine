require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Redmine::Project do
  before(:each) do 
    headers = {'X-Redmine-API-Key' => 'abcdefghijk', 'Accept' => 'application/xml'}
    headers_post_put = {'Authorization' => 'Basic Y29yZWQ6MTIzNDU2', 'Content-Type' => 'application/xml'}
    @project_id = '1'
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
      mock.get '/projects/1.xml', headers, fixture_for('projects/test-repo12'), 200
      mock.put '/projects/1.xml', headers_post_put, '', 200
      mock.post '/projects.xml', headers_post_put, '', 200
    end
  
    @taskmapper = TaskMapper.new :redmine, :server => 'http://demo.redmine.org/', :token => 'abcdefghijk'
    @klass = TaskMapper::Provider::Redmine::Project
  end

  it "should be able to load all projects" do 
    @taskmapper.projects.should be_an_instance_of(Array)
    @taskmapper.projects.first.should be_an_instance_of(@klass)
  end

  it "should be able to load projects from an array of id's" do 
    @projects = @taskmapper.projects([@project_id])
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.id.should == @project_id
  end

  it "should be able to load all projects from attributes" do 
    @projects = @taskmapper.projects(:identifier => 'redmine')
    @projects.should be_an_instance_of(Array)
    @projects.first.should be_an_instance_of(@klass)
    @projects.first.identifier.should == 'redmine'
  end

  it "should be able to find a project" do 
    @taskmapper.project.should == @klass
    @taskmapper.project.find(@project_id).should be_an_instance_of(@klass)
  end

  it "should be able to find a project by identifier" do 
    @taskmapper.project(@project_id).should be_an_instance_of(@klass)
    @taskmapper.project(@project_id).id.should == @project_id
  end

  it "should be able to update and save a project" do
    pending
    @project = @taskmapper.project(@project_id)
    @project.update!(:name => 'named').should == true
  end

  it "should be able to create a new project" do 
    pending
    @project = @taskmapper.project!(:name => 'newtest', :identifier => 'dumb', :description => 'hithere').should be_an_instance_of(@klass)
  end
end
