require 'logging'
require 'thor'

require 'RCons'
require 'RCons/DSL'
require 'RCons/DSL/Target'
require 'RCons/DSL/GenericHandler'

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
      opts[:log] = 0 if opts[:verbose]
      opts[:log] = 3 if opts[:silent]
      $logger = Logging.logger[:rcons]
      $logger.add_appenders 'stdout'
      $logger.level = opts[:log]
      puts "This is RCons v#{VERSION}."
      puts ""
      RCons.check_ruby_version
      $all_target = DSL::Target.new('all', :virtual)
    end

    default_task :graph
    class_option :log,
                 type:      :numeric,
                 banner:    '<loglevel>',
                 default:   1,
                 aliases:   '-l',
                 desc:      'Sets the log level (0 = everything, 4 = only FATAL, 5 = nothing at all)'
    class_option :verbose,
                 type:    :boolean,
                 aliases: '-v',
                 desc:    'Verbose output, same as `-l0`'
    class_option :silent,
                 type:    :boolean,
                 aliases: '-s',
                 desc:    'Silent output, same as `-l3`'

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

    desc :handler, 'Spits out the name of a possible Handler for the given file'
    long_desc <<-D
      Given a filename (no need to exist on harddrive!) you will be presented with
      the classname of the Handler that cares about this particular filetype.
    D
    def handler(filename)
      target = RCons::DSL::Target.new(filename, :guess)

      puts "#{filename} will be handled by #{(RCons::DSL::GenericHandler.get_handler(target)).class.to_s}"
    end

    desc :build, 'Builds the specified target'
    long_desc <<-D
      Tries to build the specified target with as less buildsteps as possible.
    D
    def build(targetname = :all)
      RCons::DSL.parse
      $all_target.build if targetname.to_sym == :all
    end

  end

end