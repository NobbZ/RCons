#!/usr/bin/env ruby

# We do all this work just to find the proper load path
path = __FILE__
while File.symlink?(path)
  path = File.expand_path(File.readlink(path), File.dirname(path))
end
$:.unshift(File.join(File.dirname(File.expand_path(path)), '..', 'lib'))

require 'RCons/CLI'

RCons::CLI.start
