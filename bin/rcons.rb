#!/usr/bin/env ruby

require "RCons"

include RCons

checkRubyVersion

puts "This is RCons v#{VERSION}."

clistart ARGV

require "RCons/DSL"
include RCons::DSL

$allTarget = Target.new("all", :virtual)

%w{RConstruct.rb RConsFile.rb RConstruct RConsFile}.each do |file|
  if File.exists? file
    puts "#{file} found, scanning!"
    load file
  else
    puts "#{file} not found, skipping!"
  end
end

def showDeps(dep)
  puts dep
  dep.dependencies.each do |d|
    puts d
    showDeps d
  end
end

showDeps $allTarget
