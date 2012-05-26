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
    def self.find(*arguments)
      scope   = arguments.slice!(0)
      options = arguments.slice!(0) || {}
      # By including journals, we can get Notes aka Comments
      # RedmineAPI::Issue.find(2180, :params => {:include => 'journals'})
      get_comments = {:include => 'journals'}
      if options[:params].nil?
        options[:params] = get_comments
      else
        options[:params].merge!(get_comments)
      end
      super scope, options
    end
  end

  class Project < Base
  end

end
