module TicketMaster::Provider
  module Redmine
    # Ticket class for ticketmaster-yoursystem
    #
    API = RedmineAPI::Issue

    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here

      def initialize(*object)
        if object.first
          object = object.first
          @system_data = {:client => object}
          unless object.is_a? Hash
            hash = {:repository => object.project_id,
              :description => object.description,
              :subject => object.subject,
              :status => object.status}
          else
            hash = object
          end
          super hash
        end
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

      def project_id
        self[:project_id].to_i
      end

      def self.create(*options)
        issue = API.new(options.first.merge!(:status => 'New'))
        ticket = self.new issue 
        issue.save
        ticket
      end

    end
  end
end
