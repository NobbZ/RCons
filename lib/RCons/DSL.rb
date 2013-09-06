module RCons
  module DSL
    
    class Target
      # Creates a new target.
      #
      # === Parameters
      # [name]  The name of the target, also the output path relative to working
      #         directory.
      # [type]  The type of the target, can be one of:
      #         * <tt>:executable</tt>
      #         * <tt>:intermediate</tt> (not implemented)
      #         * <tt>:source</tt> (not implemented)
      #         * <tt>:guess</tt>: RCons will try to guess the type of the target
      #           depending on its extension.
      #         * <tt>:virtual</tt>: Defines a target that just has dependencies,
      #           but not a real own target. It is used to organize other targets
      #           under a common Target.
      def initialize(name, type)
        @name = name
        @type = type
        @dependancies = []
      end
      
      # Adds an dependancy to the target
      #
      # === Parameters
      # [dependancy]  The Target that this Target depends on (please remember,
      #               that even a source file is considered a Target!).
      #               Dependancy can be on of the following types:
      #               * <tt>Target</tt>
      #               * <tt>String</tt>
      #               * <tt>Array</tt> which elements are <tt>Target</tt>s or <tt>String</tt>s
      #               A warning will be logged for elements that are invalid.
      def add_dependancy(dependancy)
        if dependancy.is_a? Target
          @dependancies << dependancy
        elsif dependancy.is_a? String
          @dependancies << Target.new(dependancy, :guess)
        elsif dependancy.is_a? Array
          dependancy.each do |d|
            self.add_dependancy(d)
          end
        else
          puts "WARNING: #{dependancy} is not a valid Target!"
        end
      end
      
      def dependencies
        @dependancies
      end
      
      def to_s
        @name
      end
    end
    
    # Creates an executable with the name target by compiling the sources.
    #
    # === Parameters
    # [target]  The name of the target without fileextensions!
    # [sources] An array of strings which contains the necessary sourcefiles, 
    #           relative to the RCons-Script
    # === Example
    #    executable "example", %w{hello.c world.c}
    # This will take <tt>hello.c</tt> and <tt>world.c</tt> and compile each of
    # them, afterwards the resulting <tt>hello.o</tt> and <tt>world.o</tt> will
    # be linked together into <tt>example</tt>
    def executable(target, sources)
      target = Target.new target, :executable
      $allTarget.add_dependancy target
      if sources.is_a? String
        sources = [sources]
      end
      sources.each_index do |i|
        t = Target.new(sources[i], :guess)
        target.add_dependancy t
      end
    end
  end
end