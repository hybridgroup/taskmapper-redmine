require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TaskMapper::Provider::Redmine::Ticket do
  let(:headers_auth) { {'X-Redmine-API-Key' => 'abcdefghijk'} }
  let(:headers_get) { headers_auth.merge('Accept' => 'application/xml') }
  let(:headers_post_put) { headers_auth.merge('Content-Type' => 'application/xml') }
  let(:project_id) { 1 }
  let(:tm) { TaskMapper.new :redmine, :server => 'http://demo.redmine.org/', :token => 'abcdefghijk' }
  let(:ticket_class) { TaskMapper::Provider::Redmine::Ticket }
  let(:ticket_id) { 1 }

  describe "Retrieving tickets" do 
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/projects/1.xml', headers_get, fixture_for('projects/test-repo12'), 200
        mock.get '/issues.xml?include=journals&project_id=1', headers_get, fixture_for('issues'), 200
        mock.get '/issues/1.xml?include=journals', headers_get, fixture_for('issues/1'), 200
      end
    end
    let(:project) { tm.project project_id }

    context "when #tickets" do 
      subject { project.tickets } 
      it { should be_an_instance_of Array }

      context "when #tickets.first" do 
        subject { project.tickets.first } 
        it { should be_an_instance_of ticket_class }
      end
    end

    context "when #tickets with an array of id's" do 
      subject { project.tickets [ticket_id] }
      it { should be_an_instance_of Array }
    end

    context "when #tickets with attributes" do 
      subject { project.tickets :id => ticket_id }
      it { should be_an_instance_of Array }
    end

    describe "Retrieving a single ticket" do 
      context "when #ticket with an id" do 
        subject { project.ticket ticket_id }
        it { should be_an_instance_of ticket_class }
      end

      context "when #ticket with attributes" do 
        subject { project.ticket :id => ticket_id }
        it { should be_an_instance_of ticket_class }
      end
    end
  end

  describe "Create and Update" do
    before(:each) do 
      ActiveResource::HttpMock.respond_to do |mock|
        mock.get '/projects/1.xml', headers_get, fixture_for('projects/test-repo12'), 200
        mock.post '/issues.xml', headers_post_put, '', 200
      end
    end
    let(:project) { tm.project project_id }

    context "when #ticket!" do 
      subject { project.ticket! :title => 'Ticket #12', :description => 'Body'}
      it { should be_an_instance_of ticket_class }
    end
    
    context "when #save" do 
      subject { project.ticket ticket_id }
    end
  end

  it "should be able to update and save a ticket" do
    pending
    @ticket = @project.ticket(1)
    @ticket.description = 'hello'
    @ticket.save.should == true
  end

end
