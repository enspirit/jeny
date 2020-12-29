module Jeny
  class Command
    module Support

      def target_for(source)
        relative = source.relative_to(from)
        relative.each_filename.map{|f|
          f.gsub(/.jeny$/, "").gsub(/_[a-zA-Z]+_/){|x|
            key = x[1...-1]
            data.has_key?(key) ? data[key] : x
          }
        }.inject(to){|t,part| t/part }
      end

      def simplify_path(path)
        if path.to_s.start_with?(Path.pwd.to_s)
          path.relative_to(Path.pwd)
        else
          path
        end
      end

    end # module Support
  end # class Command
end # module Jeny
