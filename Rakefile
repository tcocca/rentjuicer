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
    gem.add_dependency "httparty", ">= 0.6.1"
    gem.add_dependency "hashie", ">= 0.3.1"
    gem.add_dependency "rash", ">= 0.1.1"
    gem.add_dependency "will_paginate", ">= 2.3.4"
    gem.add_development_dependency "rspec", ">= 1.2.9"
    gem.add_development_dependency "webmock", ">= 1.3.4"
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
  rdoc.title = "rentjuicer #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
