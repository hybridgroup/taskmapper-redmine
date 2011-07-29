module TicketMaster::Provider
  module Redmine
    # Ticket class for ticketmaster-yoursystem
    #
    API = RedmineAPI::Issue

    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here


      def created_at
        self[:created_on]
      end

      def updated_at
        self[:updated_on]
      end

      def title
        self[:subject]
      end

      def project_id
        self[:project].id.to_i
      end

      def status
        self[:status].name
      end

      def priority
        self[:priority].name
      end

      def requestor
        self[:author].name
      end

      def assignee
        self[:author].name
      end


      def self.find_by_id(project_id, ticket_id)
        self.new API.find(ticket_id)
      end

      def self.find_by_attributes(project_id, attributes = {})
        issues = API.find(:all, build_attributes(project_id, attributes))
        issues.collect { |issue| self.new issue }
      end

      def self.build_attributes(repo, options)
        hash = {:repo => repo}.merge!(options)
      end

      def id
        self[:id].to_i
      end

      def self.create(*options)
        issue = API.new(options.first.merge!(:status => 'New', :priority => 'Normal'))
        ticket = self.new issue
        issue.save
        ticket
      end

      def comments
        warn "Redmine doesn't support comments"
        []
      end

      def comment
        warn "Redmine doesn't support comments"
        nil
      end

      def comment!
        warn "Redmine doesn't support comments"
        []
      end

    end
  end
end
