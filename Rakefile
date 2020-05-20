#!/usr/bin/env rake
require 'bundler/gem_tasks'
require 'rake/clean'
require 'rake/extensiontask'
require 'rspec/core/rake_task'
require 'rbconfig'

extension = RbConfig::CONFIG['DLEXT']
puts "EXTENSION: #{extension}"

CLEAN.include(
  '**/*.gem',         # Gem files
  '**/*.rbc',         # Rubinius
  '**/*.o',           # C object file
  '**/*.log',         # Ruby extension build log
  '**/Makefile',      # C Makefile
  '**/conftest.dSYM', # OS X build directory
  "**/*.#{extension}" # C shared object
)

Rake::ExtensionTask.new(:vmstat) do |ext|
	ext.lib_dir = 'lib/vmstat'
end

desc "Run specs"
RSpec::Core::RakeTask.new(:spec => :compile)

desc "Open an irb session preloaded with smartstat"
task :console do
  sh "irb -rubygems -I ./lib -r vmstat"
end

desc 'Default: run specs.'
task :default => :spec

at_exit { Rake::Task[:clean].invoke }
