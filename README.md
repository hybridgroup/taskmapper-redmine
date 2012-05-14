# taskmapper-redmine

This is a provider for [taskmapper](http://ticketrb.com). It provides interoperability with [Redmine](http://www.redmine.org) and it's issue tracking system through the taskmapper gem.

# Usage and Examples

First we have to instantiate a new taskmapper instance, your redmine installation should have api access enable:
    redmine = taskmapper.new(:redmine, {:server => 'http://redmine-server', :username => "foo", :password => "bar"})

If you do not pass in the server, username and password, you won't get any information.

== Finding Projects(Repositories)

You can find your own projects by doing:

    projects = redmine.projects # Will return all your repositories
    projects = redmine.projects(['your_repo1', 'your_repo2']) # You must use your projects identifier 
    project = redmine.project('your_repo') # Also use project identifier in here
	
== Finding Tickets(Issues)

    tickets = project.tickets # All open issues
    ticket = project.ticket(<issue_number>)

== Open Tickets
    
	ticket = project.ticket!({:subject=> "New ticket", :description=> "Body for the very new ticket"})

= Update a ticket
	
	ticket.subject = "New title"
	ticket.description =  "New Description"
	ticket.save

## Requirements

* rubygems (obviously)
* taskmapper gem (latest version preferred)
* jeweler gem (only if you want to repackage and develop)

The taskmapper gem should automatically be installed during the installation of this gem if it is not already installed.

## Other Notes

Since this and the taskmapper gem is still primarily a work-in-progress, minor changes may be incompatible with previous versions. Please be careful about using and updating this gem in production.

If you see or find any issues, feel free to open up an issue report.


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so we don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself so we can ignore when I pull)
* Send us a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 The Hybrid Group. See LICENSE for details.


