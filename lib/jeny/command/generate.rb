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
        changed = []
        from.glob("**/*") do |source|
          target = target_for(source)
          puts "creating #{simplify_path(target)}"
          if source.directory?
            target.mkdir_p
          else
            target.parent.mkdir_p
            file = File::Full.new(source, config)
            target_content = file.instantiate(data)
            target.write(target_content)
            changed << [target, target_content]
          end
        end
        edit_changed_files(changed)
      end

    private

      def target_for(source, data = self.data)
        relative = source.relative_to(from)
        relative.each_filename.map{|f|
          Dialect.render(f.gsub(/.jeny$/, ""), data)
        }.inject(to){|t,part| t/part }
      end

    end # class Generate
  end # class Command
end # module Jeny
