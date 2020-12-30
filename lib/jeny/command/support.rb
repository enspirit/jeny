module Jeny
  class Command
    module Support

      def target_for(source, data = self.data)
        relative = source.relative_to(from)
        relative.each_filename.map{|f|
          Dialect.render(f.gsub(/.jeny$/, ""), data)
        }.inject(to){|t,part| t/part }
      end

      def simplify_path(path)
        if path.to_s.start_with?(Path.pwd.to_s)
          path.relative_to(Path.pwd)
        else
          path
        end
      end
      module_function :simplify_path

    end # module Support
  end # class Command
end # module Jeny
