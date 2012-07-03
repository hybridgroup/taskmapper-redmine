require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Redmine::Comment do

  let(:project_id) { 1 }
  let(:ticket_id)  { 1 }
  let(:comment_id) { 1 }
  let(:comment_class) { TaskMapper::Provider::Redmine::Comment }
  let(:tm) { TaskMapper.new :redmine, :server => 'http://demo.redmine.org/', :token => 'abcdefghijk' }
  let(:headers_auth) { {'X-Redmine-API-Key' => 'abcdefghijk' } }
  let(:headers_get) { headers_auth.merge('Accept' => 'application/xml') }
  let(:headers_post) { headers_auth.merge('Content-Type' => 'application/xml') }

  before(:each) do
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
      it { should have(2).items }
    end

    context "when #comments with a list of id's" do 
      subject { ticket.comments [comment_id] }
      it { should be_an_instance_of Array }
      it { should have(1).items }
    end

    context "when #comments with a comment attribute" do 
      subject { ticket.comments :id => comment_id }
      it { should be_an_instance_of Array }
      it { should have(1).items }
    end

    describe "Retrieve a single comment" do 
      context "when #comment with an id" do 
        subject { ticket.comment comment_id } 
        it { should be_an_instance_of comment_class }
      end

      context "when #comment with an attribute" do 
        subject { ticket.comment :id => comment_id }
        it { should be_an_instance_of comment_class }
      end
    end
  end

  describe "Create and update" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/projects/1.xml', headers_get, fixture_for('projects/test-repo12'), 200
        mock.get '/issues/1.xml?include=journals', headers_get, fixture_for('issues/1'), 200
        mock.put '/issues/1.xml', headers_post, '', 200
      end
    end
    let(:project) { tm.project project_id }
    let(:ticket) { project.ticket ticket_id }

    context "when #comment!" do 
      subject { ticket.comment! :body => 'hello there boys and girls' }
      it { should be_an_instance_of comment_class }
      context "when #ticket_id" do 
        subject { ticket.comment!(:body => 'hello there boys and girls').ticket_id }
        it { should_not be_nil }
        it { should_not be_zero }
      end
    end

    context "when #save" do 
      let(:comment) { ticket.comment(comment_id) }
      let(:changed_comment) { comment.body = 'change'; comment }
      subject { changed_comment.save }
      it { should be_true }
    end
  end
end
