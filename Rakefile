require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rentjuicer"
    gem.summary = %Q{ruby api wrapper for rentjuice}
    gem.description = %Q{Ruby API wrapper for rentjuice.com built with httparty}
    gem.email = "tom.cocca@gmail.com"
    gem.homepage = "http://github.com/tcocca/rentjuicer"
    gem.authors = ["tcocca"]
    gem.add_dependency "activesupport", '~> 2.3'
    gem.add_dependency "httparty", ">= 0.6.1"
    gem.add_dependency "hashie", ">= 0.4.0"
    gem.add_dependency "rash", ">= 0.2.0"
    gem.add_dependency "will_paginate", ">= 2.3.4"
    gem.add_development_dependency "rspec", ">= 2.5.0"
    gem.add_development_dependency "webmock", ">= 1.6.2"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :test => :spec
task :default => :spec

require 'rake/rdoctask'
