require 'RCons'
require 'RCons/DSL'
require 'RCons/DSL/GenericHandler'

module RCons::DSL

  class SourceHandler < RCons::DSL::GenericHandler
    def self.get_handler(target, as_string = false)
      # Setting handler name to the files extension without (any) dots…
      handler_name = File.extname(target.name).delete '.'
      # …stripping all kind of whitespace…
      handler_name.gsub!(/[[:space:]]/, '')
      # …CamelCase underscore notation…
      handler_name.gsub!(/_([[:word:]])/) do |s|
        s.delete! '_'
        s.upcase!
      end
      # …remove everything else that is not a letter…
      handler_name.gsub!(/[^[[:word:]]]/, '')
      # …make the first letter upcase…
      handler_name[0] = handler_name[0].upcase
      # …append 'FileHandler' at the end…
      handler_name    += 'FileHandler'
      # …and (at the end) create a class called handler_name:
      $logger.info "#{target} gets assigned to #{handler_name}"
      require_relative handler_name
      (eval handler_name).new(target) if !as_string
    end
  end
end

