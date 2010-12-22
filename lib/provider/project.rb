module TicketMaster::Provider
  module Redmine
    # Project class for ticketmaster-yoursystem
    # 
    # 
    class Project < TicketMaster::Provider::Base::Project
      # declare needed overloaded methods here
      API = RedmineAPI::Project      
      
      # copy from this.copy(that) copies that into this
      def copy(project)
        project.tickets.each do |ticket|
          copy_ticket = self.ticket!(:title => ticket.title, :description => ticket.description)
          ticket.comments.each do |comment|
            copy_ticket.comment!(:body => comment.body)
            sleep 1
          end
        end
      end

      def id
        self[:identifier]
      end

      def name
        self[:identifier]
      end

      def ticket!(*options)
        TicketMaster::Provider::Redmine::Ticket.open(name, {:params => options.first})
      end

    end
  end
end
