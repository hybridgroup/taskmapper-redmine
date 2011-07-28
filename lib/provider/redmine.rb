module TicketMaster::Provider
  # This is the Yoursystem Provider for ticketmaster
  module Redmine
    include TicketMaster::Provider::Base
    PROJECT_API = RedmineAPI::Project
    TICKET_API = RedmineAPI::Issue
    
    # This is for cases when you want to instantiate using TicketMaster::Provider::Yoursystem.new(auth)
    def self.new(auth = {})
      TicketMaster.new(:redmine, auth)
    end
    
    # declare needed overloaded methods here
    def authorize(auth = {})
      @authentication ||= TicketMaster::Authenticator.new(auth)
      auth = @authentication
      if (auth.server.blank? and auth.username.blank? and auth.password.blank?)
        raise "Please you should provide server, username and password"
      end
      RedmineAPI.authenticate(auth.server, auth.username, auth.password)
    end

    def valid?
     RedmineAPI::Project.find(:all).size >= 0 
    end
  end
end
