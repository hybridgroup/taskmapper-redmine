#Reopening class to add ticket master espesific behavior without mixing it with RadmineAPI
class RedmineAPI::Issue
  def to_ticket_hash
    return  :id => id.to_i,
            :title => subject,
            :created_at => created_on,
            :updated_at => updated_on,
            :project_id => project.id.to_i,
            :status => status.name,
            :priority => priority.name,
            :requestor => author.name,
            :assignee => author.name
  end
  
  def update_with(ticket)
    subject = ticket.title
    project_id = ticket.project_id
    description = ticket.description if ticket.description
    priority_id = ticket.priority if ticket.priority
    self
  end
end
