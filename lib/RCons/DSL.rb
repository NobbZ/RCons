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
      #         * <tt>:intermediat</tt> (not implemented)
      #         * <tt>:source</tt> (not implemented)
      #         * <tt>:guess</tt>: RCons will try to guess the type of the target
      #           depending on its extension.
      def new(name, type)
        @name = name
        @type = type
        @dependancies = []
      end
      
      # Adds an dependancy to the target
      #
      # === Parameters
      # [dependancy]  The Target that this Target depends on (please remember,
      #               that even a source file is considered a Target!).
      def add_dependancy(dependancy)
        if dependancy.is_a? Target
          @dependancies += dependancy
        else dependancy.is_a? String
          @dependancies += Target.new(dependancy, :guess)
        end
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
    end
  end
end