require 'rcons'

module RCons
  class DSL
    def required_version(target_version)
      unless Gem::Dependency.new('RCons', target_version).match?('RCons', RCons::VERSION)
        puts 'You are not running the required version of RCons!'
        puts "Installed version '#{RCons::VERSION}' doesn't match '#{target_version}'"
        Kernel.exit 1
      end
    end
  end
end