module Jeny
  class Configuration

    def initialize
      yield(self) if block_given?
      @jeny_block_delimiter = "#jeny"
    end
    attr_accessor :jeny_file
    attr_accessor :jeny_block_delimiter

  end # class Configuration
end # module Jeny
