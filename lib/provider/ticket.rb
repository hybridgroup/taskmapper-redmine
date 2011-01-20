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
            hash = {:repository => object.id,
              :description => object.description,
              :title => object.subject,
              :status => object.status,
              :priority => object.priority,
              :project_id => object.id}
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
