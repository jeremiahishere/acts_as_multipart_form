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
  gem.name = "acts_as_multipart_form"
  gem.homepage = "http://github.com/jeremiahishere/acts_as_multipart_form"
  gem.license = "MIT"
  gem.summary = %Q{Multipart form engine on rails}
  gem.description = %Q{Multipart forms using custom routes}
  gem.email = "jeremiah@cloudspace.com"
  gem.authors = ["Jeremiah Hemphill", "Ethan Pemble"]
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

#general cucumber rake task
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber, 'run features that should pass') do |t|
  t.cucumber_opts = "spec/dummy/features --format progress"
end


require 'yard'
YARD::Rake::YardocTask.new

# hudson ci
require 'ci/reporter/rake/rspec'
namespace :hudson do
  def report_path
    "spec/reports/"
  end

  task :report_setup do
    rm_rf report_path
    mkdir_p report_path
  end
end
