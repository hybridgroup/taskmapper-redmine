module TaskMapper::Provider
  module Redmine
    # Project class for taskmapper-yoursystem
    # 
    # 
    class Project < TaskMapper::Provider::Base::Project
      # declare needed overloaded methods here
      API = RedmineAPI::Project      

      def initialize(*object) 
        if object.first
          object = object.first
          unless object.is_a? Hash
            hash = {:id => object.id,
                    :name => object.name,
                    :description => object.description,
                    :identifier => object.identifier,
                    :created_at => object.created_on,
                    :updated_at => object.updated_on}

          else
            hash = object
          end
          super hash
        end
      end

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
        self[:id]
      end

      def identifier
        self[:identifier]
      end
    end
  end
end
