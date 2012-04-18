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
    self.subject = ticket.title
    self.project_id = ticket.project_id 
    self.description = ticket.description if ticket.description
    self
  end
end
