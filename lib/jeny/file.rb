module Jeny
  class File

    def initialize(path, config)
      @path = path
      @config = config
    end
    attr_reader :path, :config
  
    def rewrite(data, to)
      to.write(instantiate(data))
    end

  end # class File
end # module Jeny
require_relative 'file/with_blocks'
require_relative 'file/full'
