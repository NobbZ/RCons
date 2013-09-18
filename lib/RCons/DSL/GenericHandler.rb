require 'RCons/DSL'

module RCons::DSL

  class GenericHandler

    # Returns an instance of a Target-Handler depending on its type.
    #
    # @param [Target] target the Target you want to have a Handler for.
    # @return [GenericHandler] The actual Handler for the requested type.
    def self.get_handler(target)
      case target.type
      when :virtual
#        return DSL::GenericHandler.new()
      when :executable
#        return DSL::ExecutableHandler.new(target)
      when :intermediate
#        return DSL::IntermediateHandler.new(target)
      when :source
        require 'RCons/DSL/SourceHandler'
        return SourceHandler.get_handler(target)
      else
        $logger.fatal "!" * 40
        $logger.fatal "! It is impossible to build Targets with type `#{target.type}`!"
        $logger.fatal "! Make sure #{target.name} gets a proper type assigned!"
        $logger.fatal "! Don't even know of the existance of `#{target.type}`!" unless [:guess, :unknown].include? target.type
        $logger.fatal "!" * 40
        raise "Target type can't be handled!"
      end
    end

  end
end