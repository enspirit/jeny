module Jeny
  class Command
    class Generate
      include Support

      def initialize(config, data, from, to)
        @config = config
        @data = Caser.for_hash(data)
        @from = from
        @to = to
      end
      attr_reader :config, :data, :from, :to

      def call
        puts
        from.glob("**/*") do |source|
          target = target_for(source)
          puts "creating #{simplify_path(target)}"
          if source.directory?
            target.mkdir_p
          else
            target.parent.mkdir_p
            file = if source.ext == "jeny"
              File::Full.new(source, config)
            else
              File::WithBlocks.new(source, config)
            end
            file.rewrite(data, target)
          end
        end
      end

    end # class Generate
  end # class Command
end # module Jeny
