#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'rdoc/task'
require 'rake/testtask'
require 'rake/clean'
require 'rake/notes/rake_task'

task :default => [:test]

desc "Uninstall rprojects-#{Rprojects::VERSION}.gem"
task :uninstall do
  %x{gem uninstall rprojects}
  puts "rprojects uninstalled successfully"
end

Rake::RDocTask.new do |rdoc|
  rdoc.main = "README.md"
  rdoc.title = "Rprojects Docs"
  rdoc.rdoc_dir = 'doc'
  rdoc.options << '--line-numbers'

  rdoc.rdoc_files.include(*FileList.new('*') do |list|
    list.exclude(/(^|[^.a-z])[a-z]+/)
    list.exclude('TODO')
  end.to_a)
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.exclude('TODO')
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test*.rb']
  t.verbose = true
end

CLEAN.include('pkg/*')
CLOBBER.include('pkg/*')