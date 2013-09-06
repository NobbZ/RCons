require "RCons/version"

module RCons
  
  # Checks if the current ruby version is compatible with RCons. Even if the 
  # gemspec specifies at least ruby 1.9.3 I do this test just to be sure not to
  # get any exceptions thrown in mid of compiling process!
  # 
  # @todo Colorize the output with `paint`-gem
  def checkRubyVersion
    puts "---- Checking for ruby version\n"
    puts "-- ruby version found: #{Gem.ruby_version} -> "
    if Gem.ruby_version() < Gem::Version.create("1.9.3")
      puts "NOT OK, required ruby version is >= 1.9.3!\n"
      exit 1
    end
    puts "OK!"
  end
  
  # Evaluates CLI arguments
  #
  # @param [Array<String>] args The arguments from the commandline
  def clistart(args)
    if args.is_a? Array
      true
    else
      throw "Something went terribly wrong with CLI-arguments"
    end
  end
end
