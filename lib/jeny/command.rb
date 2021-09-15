require 'optparse'
module Jeny
  class Command

    def initialize
      @config = nil
      @jeny_data = {}
    end
    attr_reader :jeny_data
    attr_reader :config

    def self.call(argv)
      new.call(argv)
    rescue Error => ex
      puts ex.message
      exit(1)
    end

    def call(argv)
      args = parse_argv!(argv, load_config!)
      case command = args.first
      when "g", "generate"
        _, from, to = args
        from, to = Path(from), Path(to)
        raise Error, "No such template `#{from}`" unless from.directory?
        to.mkdir_p
        Generate.new(@config, jeny_data, from, to).call
      when "s", "snippets"
        _, asset, *source = args
        raise Error, "Asset must be specified" if asset.nil? or Path(asset).exist?
        source = [Path.pwd] if source.empty?
        from = source.map{|t| Path(t) }
        Snippets.new(@config, jeny_data, asset, from).call
      else
        raise Error, "Unknown command `#{command}`"
      end
    end

    def parse_argv!(argv, config = Configuration.new)
      @config = config
      option_parser(config).parse!(argv)
    end

  private

    def load_config!
      jeny_file = Path.pwd/".jeny"
      jeny_file = Path.backfind(".jeny") unless jeny_file.file?
      unless jeny_file
        puts "Using default Jeny configuration"
        return Configuration.new
      end
      unless (cf = Path(jeny_file)).file?
        raise Error, "No such file `#{jeny_file}`"
      end
      unless (config = Kernel.eval(cf.read)).is_a?(Configuration)
        raise Error, "Config file corrupted, no Configuration returned"
      end
      puts "Using #{jeny_file}"
      config.tap{|c|
        c.jeny_file = cf
      }
    end

    def option_parser(config)
      option_parser ||= OptionParser.new do |opts|
        opts.banner = <<~B
          Usage: jeny [options] g[enerate] SOURCE TARGET
                 jeny [options] s[nippets] ASSET [TARGET]
        B
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
        opts.on("--git", "Use git as state manager") do
          config.state_manager = :git
        end
        opts.on("--edit-if=MATCH", "Edit files matching a given term") do |s|
          config.edit_changed_files = ->(f,c){ c =~ Regexp.new(s) }
        end
        opts.on("--[no-]edit", "Edit files having a TODO") do |s|
          config.edit_changed_files = s ? Configuration::DEFAULT_EDIT_PROC : false
        end
        opts.on("--[no-]stash", "Stash before generating snippets") do |s|
          config.state_manager_options[:stash] = s
        end
        opts.on("--[no-]commit", "Commit generated snippets") do |c|
          config.state_manager_options[:commit] = c
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
