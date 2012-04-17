require 'rubygems'
require 'active_support'
require 'active_resource'


module RedmineAPI
  class Error < StandardError; end

  class << self
    attr_reader :token
    def authenticate(server, token)
      @token = token
      @server = server
      self::Base.site = server
    end

    def resources
      @resources ||= []
    end
  end

  class Base < ActiveResource::Base
    self.format = :xml
    def self.inherited(base)
      RedmineAPI.resources << base
    end

    def self.headers
      {"X-Redmine-API-Key" => RedmineAPI.token}
    end
  end

  class Issue < Base
  end

  class Project < Base
  end

end
