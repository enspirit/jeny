module Jeny
  class File
    class Full < File

      def instantiate(data)
        context = data
        path.readlines.map{|l|
          if l =~ /^#jenyctx\s+([a-z]+)\s*$/
            context = data[$1]
            nil
          else
            Dialect.render(l, context)
          end
        }.compact.join("")
      end

    end # class Full
  end # class File
end # module Jeny
