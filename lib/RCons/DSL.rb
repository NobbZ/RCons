module RCons
  module DSL

    class Target
      # Creates a new target.
      #
      # @param  [String]  name  The name of the target, also the output path
      #   relative to working directory.
      # @param  [Symbol]  type  The type of the target, can be one of:
      #
      #   * `:executable`
      #   * `:intermediate` (not implemented)
      #   * `:source` (not implemented)
      #   * `:guess`: RCons will try to guess the  type of the target depending 
      #     on its extension.
      #   * `:virtual`: Defines a target that just has dependencies, but not a
      #     real own target. It is used to organize other targets under a common
      #     Target.
      def initialize(name, type)
        $logger.debug "Target.new #{name}, :#{type}"

        @name         = name
        @type         = type
        @dependencies = []
        @parents      = []

        case File.extname(@name)
        when '.c'
          $logger.info "Guessed type of #{@name} to ':source'"
          @type = :source if @type == :guess
          $logger.info "Creating ':intermediate' target '#{File.basename(@name, File.extname(@name))}.o'"
          inter = Target.new("#{File.basename(@name, File.extname(@name))}.o", :intermediate)
          self.parents << inter
          inter.add_dependency self
        end
      end

      # Adds an dependancy to the target
      #
      # @param  [Target, String, Array<Target, String>]  dependency  The Target
      #   that this Target depends on (please remember, that even a source file
      #   is considered a Target!).
      def add_dependency(dependency)
        $logger.debug "Target '#{@name}'.add_dependency #{dependency}"
        if dependency.is_a? Target
          @dependencies << dependency
        elsif dependency.is_a? String
          @dependencies << Target.new(dependency, :guess)
        elsif dependency.is_a? Array
          dependency.each do |d|
            self.add_dependency(d)
          end
        else
          $logger.warn "WARNING: #{dependency} is not a valid Target!"
        end
        $logger.debug @dependencies
      end

      def parents
        @parents
      end

      def dependencies
        @dependencies
      end

      def to_s
        @name
      end

      def to_dot
        $logger.debug "Depgraphing #{@name}"
        retval = "#{@name.downcase.gsub(/[^a-z0-9]/,
                                        '')}\t[label=\"#{@name}\"]\n"
        @dependencies.each do |target|
          retval += target.to_dot
          retval += "#{@name.downcase.gsub(/[^a-z0-9]/, '')} -> "
          retval += "#{target.to_s.downcase.gsub(/[^a-z0-9]/, '')}\n"
        end

        retval
      end
    end

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