module TaskMapper::Provider
  module Redmine
    # The comment class for taskmapper-redmine
    class Comment < TaskMapper::Provider::Base::Comment
      API = RedmineAPI::Issue

      def initialize(ticket_id, *object)
        if object.first
          object = object.first
          unless object.is_a? Hash
            author = object.respond_to?(:user) ? object.user : object.author
            hash = {:id => object.id.to_i,
                    :author => author.name,
                    :body => object.notes,
                    :update_at => object.created_on,
                    :created_at => object.created_on,
                    :ticket_id => ticket_id
                    }
          else
            hash = object
          end
          super hash
        end
      end

      def self.find_by_id(project_id, ticket_id, id)
        self.search(ticket_id).select { |journal| journal.id == id.to_i }.first
      end

      def self.find_by_attributes(project_id, ticket_id, attributes = {})
        search_by_attribute(self.search(ticket_id), attributes)
      end

      def self.search(ticket_id)
        API.find(ticket_id).journals.inject([]) do |arr, journal|
          arr << self.new(ticket_id, journal) if journal.notes.present?
          arr
        end
      end

      def self.create(*options)
        first = options.first
        ticket_id = first.delete(:ticket_id) || first.delete('ticket_id')
        notes = first.delete(:body) || first.delete('body')
        journal = API.find(ticket_id)
        journal.notes = notes
        journal.save
        self.new(ticket_id, journal)
      end
    end
  end
end
