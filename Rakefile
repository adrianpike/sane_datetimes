# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "sane_datetimes"
  gem.homepage = "http://github.com/adrianpike/sane_datetimes"
  gem.license = "MIT"
  gem.summary = %Q{sane_datetimes gives you a friendly formtastic input for dates & times.}
  gem.description = %Q{Rails normally gives you an ugly set of select fields for datetime select. SaneDatetimes monkeypatches ActiveRecord to allow for a new format of multi-param input for Times, and includes a sort of hacked Formtastic plugin that gives you two text fields. One for the date and one for the time. }
  gem.email = "adrian@pikeapps.com"
  gem.authors = ["Adrian Pike"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "sane_datetimes #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
