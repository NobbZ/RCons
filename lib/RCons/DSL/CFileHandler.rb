require 'English'

module RCons::DSL

  class CFileHandler < SourceHandler
    attr_reader :target

    def initialize(target)
      @target = target
    end

    # @todo Compiling of the source files should be done by the OFileHandler and
    #   CFileHandler doesn't really need a build method, but a scan_for_headers
    #   instead. I will take a look into how to exactly get that running later.
    #   Also eventually found header-files need to be created as dependencies!
    #   But I am quite unsure if they are dependencies of the object- or the c-file.
    def build
      command = "gcc -c -x c -o #{File.basename(@target.name, '.c')+'.o'} #{@target.name}"
      $logger.info "Running `#{command}`"
      `#{command}`
      if $CHILD_STATUS.to_i == 0
        $logger.info "Successfully compiled #{target.name} to #{File.basename(@target.name, '.c')+'.o'}"
      else
        $logger.fatal "Couldn't compile #{target.name} to #{File.basename(@target.name, '.c')+'.o'}"
        $logger.fatal 'Please read the output above this lines'
        raise "Couldn't compile #{target.name} to #{File.basename(@target.name, '.c')+'.o'}"
      end
    end
  end
end