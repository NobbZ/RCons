module RCons::DSL

  # A possible {Target Target} for the compiling process.
  class Target
    # @!attribute [r] dependencies
    #   @return [Array<Target>] an Array of {Target Targets} this {Target Target}
    #     depends on.
    # @!attribute [r] name
    #   @return [String] the name of the target. For targets that correspond to
    #     a file in the filesystem, this is also the filename and path relative
    #     to the project folder.
    # @!attribute [r] parents
    #   @return [Array<Target>] an Array of {Target Targets} this {Target Target}
    #     is a dependency for.
    #   @todo Isn't resolved completely and seems to have huge holes at some points.
    # @!attribute [r] type
    #   @return [Symbol] the type of the {Target Target}. Can be one of:
    #     <dl>
    #       <di><tt>:executable</tt><di><dd>This {Target Target} will be linked into a executable file.</dd>
    #       <di><tt>:intermediate</tt></di><dd>Dummy text</dd>
    #       <di><tt>:source</tt></di><dd>Dummy text</dd>
    #       <di><tt>:guess</tt></di><dd>RCons will try to guess the  type of the target depending on its extension.</dd>
    #       <di><tt>:virtual</tt></di><dd>Defines a target that just has dependencies, but not a real own target. It is used to organize other targets under a common Target.</dd>
    #     </dl>
    attr_reader :dependencies,
                :name,
                :parents,
                :type

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

      if @type == :guess
        case File.extname(@name)
        when '.c'
          $logger.info "Guessed type of #{@name} to ':source'"
          @type = :source if @type == :guess
          $logger.info "Creating ':intermediate' target '#{File.basename(@name, File.extname(@name))}.o'"
          inter = Target.new("#{File.basename(@name, File.extname(@name))}.o", :intermediate)
          self.parents << inter
          inter.add_dependency self
        when '.o'
          $logger.info "Guessed type of #{@name} to ':intermediate'"
          @type = :intermediate if @type == :guess
        else
          $logger.warn "Type of #{@name} is unknown!"
          @type = :unknown if @type == :guess
        end
      end
    end

    # Adds an dependancy to the target
    #
    # @param  [Target, String, Array<Target, String>]  dependency  The Target
    #   that this Target depends on (please remember, that even a source file
    #   is considered a Target!).
    def add_dependency(dependency)
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
    end

    # String representation of the {Target Target}
    #
    # @return [String] The String representation of the {Target Target}.
    def to_s
      @name
    end

    # GraphViz representation of this {Target Target}.
    #
    # @param [GraphViz] g The in-memory representation of the graph
    def to_dot(g)
      $logger.debug "Add node for #{@name}"
      g.add_node @name.downcase.gsub(/[^A-Za-z0-9]/, ''), {label: @name}
      @dependencies.each do |d|
        d.to_dot g
        $logger.debug "Adding edge from #{@name} to #{d}"
        g.add_edge @name.downcase.gsub(/[^a-z0-9]/, ''),
                   d.to_s.downcase.gsub(/[^a-z0-9]/, ''),
                   {}
      end
    end
  end

end
