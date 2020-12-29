module Jeny
  class Command
    class Snippets
      include Support

      def initialize(config, data, asset, from)
        @config = config
        @data = { asset => Caser.for_hash(data) }
        @asset = asset
        @from = from
      end
      attr_reader :config, :data, :asset, :from

      alias :to :from

      def call
        puts
        from.glob("**/*") do |source|
          next if source.directory?
          puts "snippets #{simplify_path(source)}"
          file = if source.ext =~ /\.?jeny/
            File::Full.new(source, config)
          else
            File::WithBlocks.new(source, config)
          end
          file.rewrite(data, target_for(source))
        end
      end

    end # class Snippets
  end # class Command
end # module Jeny
