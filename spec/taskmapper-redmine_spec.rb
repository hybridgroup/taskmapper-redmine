require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Redmine do

  before :each do 
    headers = {'Authorization' => 'Basic Y29yZWQ6YWZkZA==', 'Accept' => 'application/xml'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
    end
  end

  it "should be able to instantiate a new instance" do
    taskmapper = TaskMapper.new(:redmine, :server => 'http://redmine.server', :token => 'kdkjkladkaldj')
    taskmapper.should be_an_instance_of(TaskMapper)
    taskmapper.should be_a_kind_of(TaskMapper::Provider::Redmine)
  end

end
