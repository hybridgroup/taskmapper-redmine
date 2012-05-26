require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Redmine::Comment do

  let(:project_id) { 1 }
  let(:ticket_id)  { 1 }
  let(:comment_id) { 1 }
  let(:klass)      { TaskMapper::Provider::Redmine::Comment }
  let(:taskmapper) { TaskMapper.new :redmine, :server => 'http://demo.redmine.org/', :token => 'abcdefghijk' }
  let(:project)    { taskmapper.project(project_id) }

  before(:all) do
    headers = {'X-Redmine-API-Key' => 'abcdefghijk', 'Accept' => 'application/xml'}
    headers_post_put = {'X-Redmine-API-Key' => 'abcdefghijk', 'Content-Type' => 'application/xml'}
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get '/projects.xml', headers, fixture_for('projects'), 200
      mock.get '/projects/1.xml', headers, fixture_for('projects/test-repo12'), 200
      mock.get '/issues.xml?project_id=1', headers, fixture_for('issues'), 200
      mock.get '/issues.xml', headers, fixture_for('issues'), 200
      mock.get '/issues/1.xml?include=journals', headers, fixture_for('issues/1'), 200
      mock.put '/issues/1.xml', headers_post_put, '', 200
      mock.post '/issues.xml', headers_post_put, '', 200
    end
  end

  before(:each) do
    @ticket = project.ticket(ticket_id)
  end

  it "should be able to load all comments" do
    comments = @ticket.comments
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(klass)
  end
  
  it "should be able to load all comments based on 'id's" do
    comments = @ticket.comments([comment_id])
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(klass)
    comments.first.id.should == comment_id
  end
  
  it "should be able to load all comments based on attributes" do
    comments = @ticket.comments(:id => comment_id)
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(klass)
  end
  
  it "should be able to load a comment based on id" do
    comment = @ticket.comment(comment_id)
    comment.should be_an_instance_of(klass)
    comment.id.should == comment_id
  end
  
  it "should be able to load a comment based on attributes" do
    comment = @ticket.comment(:id => comment_id)
    comment.should be_an_instance_of(klass)
  end
  
  it "should return the class" do
    @ticket.comment.should == klass
  end
  
  it "should be able to create a comment for a given task" do
    comment = @ticket.comment!(:body => 'hello there boys and girls')
    comment.should be_an_instance_of(klass)
    comment.ticket_id.should_not be_nil
    comment.ticket_id.should_not == 0
  end
end
