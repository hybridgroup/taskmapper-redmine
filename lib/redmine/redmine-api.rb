require 'rubygems'
require 'active_support'
require 'active_resource'


module RedmineAPI
  class Error < StandardError; end

  class << self
    def authenticate(server, username, password)
      @username = username
      @password = password
      @server = server
      self::Base.user = username
      self::Base.password = password
      self::Base.site = server
    end

    def resources
      @resources = []
    end
  end

  class Base < ActiveResource::Base
    def self.inherited(base)
      RedmineAPI.resources << base
    end
  end

  class Issue < Base
  end

  class Project < Base
    def tickets(options = {})
      Issue.find(:all, :params => options.update(:project_id => id)) 
    end
  end

end
