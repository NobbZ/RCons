class CFileHandler
  attr_reader :target

  def initialize(target)
    @target = target
  end

  def build
    `gcc -o #{File.basename(@target.name, '.c')+'.o'} #{@target.name}`
  end
end