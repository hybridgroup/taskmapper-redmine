require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "ticketmaster-redmine"
    gem.summary = %Q{Ticketmaster Provider for Redmine}
    gem.description = %Q{Allows ticketmaster to interact with Your System.}
    gem.email = "george.rafael@gmail.com"
    gem.homepage = "http://bandw.tumblr.com"
    gem.authors = ["Rafael George"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_dependency "ticketmaster", ">= 0.1.0"
    gem.add_dependency "activesupport", ">= 2.3.2"
    gem.add_dependency "activeresource", ">= 2.3.2"
    gem.add_dependency "addressable", ">= 2.1.2"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ticketmaster-redmine#{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
