require "RCons/version"

module RCons
  
  # Checks for a supported version of ruby
  def checkRubyVersion
    if Gem.ruby_version() < Gem::Version.create("1.9.3")
      throw "Incompatible ruby Version used! Please update to Ruby 1.9.3."
    end
  end
  
  # Evaluates CLI arguments
  #
  # === Parameters
  # [args]  The arguments from the commandline
  def clistart(args)
    if args.is_a? Array
      true
    else
      throw "Something went terribly wrong with CLI-arguments"
    end
  end
end
