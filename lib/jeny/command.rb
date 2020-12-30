require 'optparse'
module Jeny
  class Command

    def initialize
      @jeny_data = {}
      @jeny_file = nil
    end
    attr_reader :jeny_data

    def self.call(argv)
      new.call(argv)
    rescue Error => ex
      puts ex.message
      exit(1)
    end

    def call(argv)
      args = option_parser.parse!(argv)
      config = load_config!
      command = args.first
      case command
      when "g", "generate"
        _, from, to = args
        from, to = Path(from), Path(to)
        raise Error, "No such template `#{from}`" unless from.directory?
        to.mkdir_p
        Generate.new(config, jeny_data, from, to).call
      when "s", "snippets"
        _, asset, source = args
        raise Error, "Asset must be specified" if asset.nil? or Path(asset).exist?
        source ||= Path.pwd
        Snippets.new(config, jeny_data, asset, Path(source)).call
      else
        raise Error, "Unknown command `#{command}`"
      end
    end

  private

    def load_config!
      @jeny_file = Path.pwd/".jeny"
      @jeny_file = Path.backfind(".jeny") unless @jeny_file.file?
      unless @jeny_file
        puts "Using default Jeny configuration"
        return Configuration.new
      end
      unless (cf = Path(@jeny_file)).file?
        raise Error, "No such file `#{@jeny_file}`"
      end
      unless (config = Kernel.eval(cf.read)).is_a?(Configuration)
        raise Error, "Config file corrupted, no Configuration returned"
      end
      puts "Using #{@jeny_file}"
      config.tap{|c|
        c.jeny_file = cf
      }
    end

    def option_parser
      option_parser ||= OptionParser.new do |opts|
        opts.banner = <<~B
          Usage: jeny [options] g[enerate] SOURCE TARGET
                 jeny [options] s[nippets] ASSET [TARGET]
        B
        opts.on('-c path/to/config.rb') do |path|
          @jeny_file = Path(path)
        end
        opts.on("-d key:value", "Add generation data") do |pair|
          k, v = pair.split(':')
          @jeny_data[k] = v
        end
        opts.on("-f datafile", "Take generation data from a file") do |file|
          file = Path(file)
          raise Error, "No such file: #{file}" unless file.exists?
          require 'yaml' if file.ext == 'yml' || file.ext == 'yaml'
          require 'json' if file.ext == 'json'
          @jeny_data = file.load
        end
        opts.on("-v", "--version", "Prints version") do
          puts "Jeny v#{VERSION}"
          exit
        end
        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end
    end

  end # class Command
end # module Jeny
require_relative 'command/support'
require_relative 'command/generate'
require_relative 'command/snippets'
