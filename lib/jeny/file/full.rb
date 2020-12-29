module Jeny
  class File
    class Full < File

      CONTEXT_RGX = /^#jenyctx\s+([a-z]+)\s*$/

      def instantiate_context(data)
        if path.readlines.first =~ CONTEXT_RGX
          data[$1]
        else
          data
        end
      end

      def instantiate(data)
        path.readlines.map{|l|
          next if l =~ CONTEXT_RGX
          Dialect.render(l, data)
        }.compact.join("")
      end

    end # class Full
  end # class File
end # module Jeny
