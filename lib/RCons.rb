require 'graphviz'

require 'RCons/version'

module RCons

  # Checks if the current ruby version is compatible with RCons. Even if the 
  # gemspec specifies at least ruby 1.9.3 I do this test just to be sure not to
  # get any exceptions thrown in mid of compiling process!
  def self.check_ruby_version
    $logger.debug 'Checking for ruby version'
    $logger.debug "ruby version found: #{Gem.ruby_version}; needed: >= 1.9.3"
    if Gem.ruby_version() < Gem::Version.create('1.9.3')
      $logger.fatal "Ruby Version NOT OK, required ruby version is >= 1.9.3!\n"
      exit 1
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
  def self.draw_graph(view = false)
    $logger.info 'Creating depGraph in memory'
    graph = GraphViz::new(:G, type: :digraph) do |g|
      $all_target.to_dot g
    end
    $logger.info 'Saving depGrpah.svg'
    graph.output(svg: 'depGraph.svg', nothugly: true)
    if view
      $logger.info 'Opening depGraph.svg'
      `xdg-open depGraph.svg`
    end
  end
end
