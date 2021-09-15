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

      def call
        puts
        sm, state = config.state_manager, OpenStruct.new
        sm.stash(state) if config.sm_stash?

        changed = []
        from.each do |source|
          parent = source
          parent = source.parent until parent.directory?
          _call(source, parent, changed)
        end

        sm.commit(changed.map(&:first), state) if config.sm_commit?

        edit_changed_files(changed)
      rescue
        sm.reset(changed.map(&:first), state)
        raise
      ensure
        sm.unstash(state) if config.sm_stash?
      end

      def _call(source, parent, changed)
        raise ArgumentError, parent unless parent.directory?

        if source.file?
          return if config.ignore_file?(source)
          pair = snippet_it(source, parent)
          changed << pair if pair
        elsif source.directory?
          source.glob("**/*").each do |sub|
            next if sub.directory?
            _call(sub, parent, changed)
          end
        else
          raise ArgumentError, "Not a file, nor or directly: #{source}"
        end
      end
      private :_call

      def snippet_it(source, parent)
        target, target_content = nil
        if source.ext =~ /\.?jeny/
          file = File::Full.new(source, config)
          if file.has_jeny_context?
            ctx = file.instantiate_context(data)
            if ctx
              target_content = file.instantiate(ctx)
              target = target_for(source, ctx)
              target.parent.mkdir_p
              target.write(target_content)
              puts "snippets #{simplify_path(target)}"
            end
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
        raise Error, msg, ex.backtrace
      end

    private

      def target_for(source, data = self.data)
        Path(Dialect.render(source.to_s.gsub(/\.jeny/, ""), data))
      end

    end # class Snippets
  end # class Command
end # module Jeny
