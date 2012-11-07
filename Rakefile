#!/usr/bin/env rake
require 'rubygems'
require 'rake'
require "bundler/gem_tasks"

$: << File.expand_path(File.dirname(__FILE__) + "/lib")
require 'allen'

task :default => :spec

task :spec do
  sh "rspec spec"
end

