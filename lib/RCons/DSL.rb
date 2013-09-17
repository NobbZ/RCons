require 'graphviz'

module RCons
  module DSL

    # Creates an executable with the name target by compiling the sources.
    #
    # @param [String]                 target  The name of the target without
    #   fileextensions!
    # @param [String, Array<String>]  sources An array of strings which contains
    #   the necessary sourcefiles, relative to the RCons-Script
    #
    # @example
    #   executable "example", ["hello.c", "world.c"]
    # This will take `hello.c` and `world.c` and compile each of
    # them, afterwards the resulting `hello.o` and `world.o` will
    # be linked together into `example`
    def executable(target, sources)
      $logger.info "Found target '#{target}' with following sources/dependencies:"
      $logger.info sources
      target = Target.new target, :executable
      $allTarget.add_dependency target
      if sources.is_a? String
        sources = [sources]
      end
      sources.each do |s|
        t = Target.new(s, :guess)
        target.add_dependency t.parents
      end
    end
  end
end