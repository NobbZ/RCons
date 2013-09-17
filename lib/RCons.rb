require 'RCons/version'

module RCons

  # Checks if the current ruby version is compatible with RCons. Even if the 
  # gemspec specifies at least ruby 1.9.3 I do this test just to be sure not to
  # get any exceptions thrown in mid of compiling process!
  def checkRubyVersion
    $logger.debug 'Checking for ruby version'
    $logger.debug "ruby version found: #{Gem.ruby_version}; needed: >= 1.9.3"
    if Gem.ruby_version() < Gem::Version.create('1.9.3')
      $logger.fatal "Ruby Version NOT OK, required ruby version is >= 1.9.3!\n"
      exit 1
    end
  end

  # Evaluates CLI arguments
  #
  # @param [Array<String>] args The arguments from the commandline
  def clistart(args)
    $logger.debug 'Invoked with params:'
    $logger.debug args
    if args.is_a? Array
      case args[0]
      when 'graph'
        $logger.info 'Recognized command \'graph\''
        drawGraph(args.include?("-o") | args.include?("--open") | args.include?("--view"))
      else
        $logger.info 'No command found in arguments, doing nothing'
      end
      $logger.info "Finished task '#{args[0]}'"
      true
    else
      throw 'Something went terribly wrong with CLI-arguments'
    end
  end

  # Draws a dependency-graph of the files and targets
  #
  # @param [Boolean] view Defines if the graph should be opened for viewing
  #   after generation
  #   <dl>
  #     <di>`true`</di><dd>tries to open the graph in external viewer</dd>
  #     <di>`false`</di><dd>just quit without viewing the graph</dd>
  #   <dl>
  def drawGraph(view = false)
    $logger.info "Creating depGraph.dot"
=begin
    File.open('depGraph.dot', 'wt') do |dotFile|
      dotFile.print "digraph G {\n"
      dotFile.print "  all [label=\"all\"]\n"
      dotFile.print $allTarget.to_dot
      dotFile.print "}\n"
    end
=end
    require 'graphviz'
    graph = GraphViz::new(:G, type: :digraph) do |g|
      $allTarget.to_dot g
    end
    $logger.info 'Creating depGrpah.svg'
    graph.output(svg: "depGraph.svg", nothugly: true)
    #`dot -Tsvg -odepGraph.svg depGraph.dot`
    if view
      $logger.info 'Opening depGraph.svg'
      `xdg-open depGraph.svg`
    end
  end
end
