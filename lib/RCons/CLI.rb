require 'logging'
require 'thor'

require 'RCons'
require 'RCons/DSL'
require 'RCons/DSL/Target'

module RCons

  class CLI < Thor
    include Thor::Actions

    def initialize(*)
      super


      Logging.color_scheme('bright',
                           levels: {
                             debug: :blue,
                             info:  :green,
                             warn:  :yellow,
                             error: :red,
                             fatal: [:white, :on_red]
                           },
                           date:   :cyan,
                           logger: :cyan
      )

      Logging.appenders.stdout(
        'stdout',
        layout: Logging.layouts.pattern(
                  pattern:      '[%d]%6l: %m\n',
                  color_scheme: 'bright'
                )
      )

      opts    = options.dup
      $logger = Logging.logger[:rcons]
      $logger.add_appenders 'stdout'
      $logger.level = opts[:log]
      $logger.info "This is RCons v#{VERSION}."
      RCons.check_ruby_version
      $all_target = DSL::Target.new('all', :virtual)
    end

    default_task :graph
    class_option :log,
                 type:      :numeric,
                 banner:    '<loglevel>',
                 default:   1,
                 aliases:   '-l',
                 desc:      'Sets the log level',
                 long_desc: <<-EOD
Sets the log output level:
  * 0 -> Debug, Info, Warn, Error, Fatal
  * 1 -> Info, Warn, Error, Fatal
  * 2 -> Warn, Error, Fatal
  * 3 -> Error, Fatal
  * 4 -> Fatal
  * 5 -> No output!
    EOD
    class_option :verbose,
                 type:    :boolean,
                 aliases: '-v',
                 desc:    'Verbose output, same as `-l 0`'
    class_option :silent,
                 type:    :boolean,
                 aliases: '-s',
                 desc:    'Silent output, same as `-l 3`'

    desc 'graph', 'Draws the dependency graph'
    long_desc <<-EOD
      Draws the dependency graph of all known targets derived from RConsFile
    EOD
    method_option 'view',
                  aliases: '-V',
                  type:    :boolean,
                  default: false,
                  desc:    'Opens the graph in viewer after generating it'

    def graph
      opts = options.dup
      RCons::DSL.parse
      RCons.draw_graph opts[:view]
    end

  end

end