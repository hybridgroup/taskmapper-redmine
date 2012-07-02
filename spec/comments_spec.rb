require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Redmine::Comment do

  let(:project_id) { 1 }
  let(:ticket_id)  { 1 }
  let(:comment_id) { 1 }
  let(:klass)      { TaskMapper::Provider::Redmine::Comment }
  let(:tm) { TaskMapper.new :redmine, :server => 'http://demo.redmine.org/', :token => 'abcdefghijk' }
  let(:headers_auth) { {'X-Redmine-API-Key' => 'abcdefghijk' } }
  let(:headers_get) { headers_auth.merge('Accept' => 'application/xml') }
  let(:headers_post) { headers_auth.merge('Content-Type' => 'application/xml') }

  before(:each) do
    @ticket = project.ticket(ticket_id)
  end

  describe "Retrieving comments" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/projects/1.xml', headers_get, fixture_for('projects/test-repo12'), 200
        mock.get '/issues/1.xml?include=journals', headers_get, fixture_for('issues/1'), 200
      end
    end
    let(:project) { tm.project project_id }
    let(:ticket) { project.ticket ticket_id }

    context "when #comments" do 
      subject { ticket.comments } 
      it { should be_an_instance_of Array }
    end
  end

  it "should be able to load all comments" do
    pending
    comments = @ticket.comments
    comments.size.should eq(2)
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(klass)
  end

  it "should be able to load all comments based on 'id's" do
    pending
    comments = @ticket.comments([comment_id])
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(klass)
    comments.first.id.should == comment_id
  end

  it "should be able to load all comments based on attributes" do
    pending
    comments = @ticket.comments(:id => comment_id)
    comments.should be_an_instance_of(Array)
    comments.first.should be_an_instance_of(klass)
  end

  it "shoultmd be able to load a comment based on id" do
    pending
    comment = @ticket.comment(comment_id)
    comment.should be_an_instance_of(klass)
    comment.id.should == comment_id
  end

  it "should be able to load a comment based on attributes" do
    pending
    comment = @ticket.comment(:id => comment_id)
    comment.should be_an_instance_of(klass)
  end

  it "should be able to create a comment for a given task" do
    pending
    comment = @ticket.comment!(:body => 'hello there boys and girls')
    comment.should be_an_instance_of(klass)
    comment.ticket_id.should_not be_nil
    comment.ticket_id.should_not == 0
  end
end
