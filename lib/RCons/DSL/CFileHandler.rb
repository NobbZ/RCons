require 'English'

class CFileHandler
  attr_reader :target

  def initialize(target)
    @target = target
  end

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