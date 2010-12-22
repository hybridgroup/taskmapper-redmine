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
            hash = {:repository => object.name,
              :tracker => object.tracker,
              :status => object.status,
              :priority => object.priority,
              :author => object.author,
              :category => object.category,
              :subject => object.subject,
              :description => object.description,
              :start_date => object.start_date,
              :due_date => object.due_date,
              :done_ratio => object.done_ratio,
              :estimated_hours => object.estimated_hours,
              :name => object.id,
              :id => object.id}
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

    end
  end
end
