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
      if auth.server.blank? and auth.token.blank?
        raise "Please you should provide server and token"
      end

      RedmineAPI.authenticate(auth.server, auth.token)
    end

    def valid?
      begin
        RedmineAPI::Project.find(:all).size >= 0 
      rescue
        false
      end
    end
  end
end
