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

      def self.open(project_id, *options)
        data = Hashie::Mash.new options.first
        self.new API.new(:project_id => project_id, 
                :repository => project_id,
              :tracker => data.tracker,
              :status => data.status,
              :priority => data.priority,
              :author => data.author,
              :category => data.category,
              :subject => data.subject,
              :description => data.description,
              :start_date => data.start_date,
              :due_date => data.due_date,
              :done_ratio => data.done_ratio,
              :estimated_hours => data.estimated_hours,
              :name => data.id,
              :id => data.id)

      end

      def comments 
        warn "Redmine does not have comments in it's API"
        []
      end

      def comment
        warn "Redmine does not have comments in it's API"
        nil
      end

      def comment!
        warn "Redmine does not have comments in it's API"
      end

    end
  end
end
