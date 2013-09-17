module RCons::DSL

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

    def parents
      @parents
    end

    def dependencies
      @dependencies
    end

    def to_s
      @name
    end

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
