#!/usr/bin/env ruby

require "RCons"
require "logging"

# Setting up the logger

Logging.color_scheme('bright',
                     levels:  {
                       debug: :blue,
                       info:  :green,
                       warn:  :yellow,
                       error: :red,
                       fatal: [:white, :on_red]
                     },
                     date:    :blue,
                     logger:  :cyan
)

Logging.appenders.stdout(
  'stdout',
  layout: Logging.layouts.pattern(
#            pattern:      '[%d] %-5l %c: %m\n',
            pattern:      '[%5l] %m\n',
            color_scheme: 'bright'
          )
)

$logger = Logging.logger[:rcons]
$logger.add_appenders 'stdout'
$logger.level = :debug

include RCons

checkRubyVersion

$logger.info "This is RCons v#{VERSION}."

clistart ARGV

require "RCons/DSL"
include RCons::DSL

$allTarget = Target.new("all", :virtual)

%w{RConstruct.rb RConsFile.rb RConstruct RConsFile}.each do |file|
  if File.exists? file
    $logger.info "#{file} found, scanning!"
    load file
    break
  else
    $logger.debug "#{file} not found, skipping!"
    if file=='RConsFile'
      $logger.fatal 'No RCons file found'
      exit(1)
    end
  end
end


