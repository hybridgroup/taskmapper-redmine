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
end
