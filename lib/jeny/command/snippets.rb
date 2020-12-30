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
        state = OpenStruct.new
        config.state_manager.stash(state)
        changed = []
        from.glob("**/*").each do |source|
          next if source.directory?
          next if config.ignore_file?(source)
          pair = snippet_it(source)
          changed << pair if pair
        end
        config.state_manager.commit(changed.map(&:first), state)
        to_open = changed
          .select{|pair| config.should_be_edited?(*pair) }
          .map{|pair| simplify_path(pair.first) }
        config.open_editor(to_open) unless to_open.empty?
      rescue
        config.state_manager.reset(changed.map(&:first), state)
        raise
      ensure
        config.state_manager.unstash(state)
      end

      def snippet_it(source)
        target, target_content = nil
        if source.ext =~ /\.?jeny/
          file = File::Full.new(source, config)
          if file.has_jeny_context?
            ctx = file.instantiate_context(data)
            target_content = file.instantiate(ctx)
            target = target_for(source, ctx)
            target.parent.mkdir_p
            target.write(target_content)
            puts "snippets #{simplify_path(target)}"
          end
        else
          file = File::WithBlocks.new(source, config)
          if file.has_jeny_blocks?
            target_content = file.instantiate(data)
            target = target_for(source)
            target.write(target_content)
            puts "snippets #{simplify_path(target)}"
          end
        end
        target ? [target, target_content] : nil
      rescue => ex
        msg = "Error in `#{simplify_path(source)}`: #{ex.message}"
        raise Error, msg
      end

    end # class Snippets
  end # class Command
end # module Jeny
