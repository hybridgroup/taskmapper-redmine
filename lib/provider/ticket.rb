module TicketMaster::Provider
  module Redmine
    # Ticket class for ticketmaster-yoursystem
    #
    API = RedmineAPI::Issue

    class Ticket < TicketMaster::Provider::Base::Ticket
      # declare needed overloaded methods here

      def initialize(*args)
        case args.first
          when Hash then super args.first
          when RedmineAPI::Issue then super args.first.to_ticket_hash
          else raise ArgumentError.new
        end
      end
      
      def self.copy(issue_hash, ticket_hash)
      end

      def created_at
        self[:created_on]
      end

      def updated_at
        self[:updated_on]
      end

      def project_id
        self[:project_id]
      end

      def status
        self[:status].name
      end

      def priority
        self[:priority]
      end

      def requestor
        self[:author].name
      end

      def assignee
        self[:author].name
      end

      def id
        self[:id].to_i
      end

      def self.find_by_id(project_id, ticket_id)
       self.new API.find(:first, :id => ticket_id)
      end

      def self.find_by_attributes(project_id, attributes = {})
       issues = API.find(:all, attributes_for_request(project_id, attributes))
       issues.collect { |issue| self.new issue }
      end

      def self.attributes_for_request(project_id, options)
       hash = {:params => {:project_id => project_id}}.merge!(options)
      end

      def self.create(attributes)
        ticket = self.new(attributes)
        ticket if ticket.save
      end
      
      def save
        new? ? to_issue.save : update
      end
      
      def new?
        id.nil? || id.zero?
      end
      
      def to_issue
        API.new.tap do |i|
          i.subject = title
          i.project_id = project_id
          i.description = description if desciprtion
          i.priority_id = priority if priority
        end 
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
