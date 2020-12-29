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
            file = File::Full.new(source, config)
            ctx = file.instantiate_context(data)
            instantiated = file.instantiate(ctx)
            target = target_for(source, ctx)
            target.parent.mkdir_p
            target.write(instantiated)
          else
            file = File::WithBlocks.new(source, config)
            file.rewrite(data, target_for(source))
          end
        end
      end

    end # class Snippets
  end # class Command
end # module Jeny
