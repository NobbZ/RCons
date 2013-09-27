require 'rcons'

module RCons
  # The definition of the DSL of RCons.
  #
  # You can use it as in the following example:
  #
  # ```ruby
  # ##RConstruct.rb
  # #!/usr/bin/env ruby
  #
  # require 'rcons/dsl'
  # project = RCons::DSL.new
  #
  # project.requires_rcons_version '~> 1.0.0'
  # project.object_file 'test'
  # project.executable 'test', 'test'
  # ```
  class DSL

    # Requires a specific version of RCons
    #
    # You can specify a specific version of RCons with this. It will exit the
    # process if the target_version doesn't match the version of the installed
    # RCons-gem.
    #
    # @param [String] target_version The target version of RCons, you can use
    #   RubyGems-Version-matchers here as in `'~> 1.2.4'`.
    #
    #   ```ruby
    #   project = RCons::DSL.new
    #   project.require_rcons_version '~> 1.2.4'
    #   ```
    #
    #   This example will exit if you have RCons version 1.2.3 installed but
    #   continue if you have 1.2.10
    def requires_rcons_version(target_version)
      unless Gem::Dependency.new('RCons', target_version).match?('RCons', RCons::VERSION)
        puts 'You are not running the required version of RCons!'
        puts "Installed version '#{RCons::VERSION}' doesn't match '#{target_version}'"
        Kernel.exit 1
      end
    end

    # @param [String, #to_s] target_name
    # @param [String, #to_s] file_name
    # @param [Array<String>, String, #to_s] source_file
    def object_file(target_name, file_name = nil, source_file = nil)
      target = RCons::Target.new
      target.name = target_name
      if File.extname(target_name).empty? && file_name.nil?
        target.file_name = "#{target_name}.o"
      elsif File.extname(target_name) == '.o'
        target.file_name = target_name
      end
      if File.extname(target_name).empty? || source_file.nil?
        target.source_name = "#{target_name}.c"
      end
      target
    end
  end
end