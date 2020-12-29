module Jeny
  class Configuration

    def initialize
      yield(self) if block_given?
      @jeny_block_delimiter = "#jeny"
      @ignore_pattern = /^(vendor|.bundle)/
    end
    attr_accessor :jeny_file
    attr_accessor :jeny_block_delimiter
    attr_accessor :ignore_pattern

    def ignore_file?(file)
      file = Command::Support.simplify_path(file)
      file =~ ignore_pattern
    end

  end # class Configuration
end # module Jeny
