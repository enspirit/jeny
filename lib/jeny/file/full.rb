module Jeny
  class File
    class Full < File

      def context_rgx
        /^#{config.jeny_block_delimiter}\((?<asset>[a-z]+)\)\s*$/
      end

      def has_jeny_context?
        path.readlines.first =~ context_rgx
      end

      def instantiate_context(data)
        if match = path.readlines.first.match(context_rgx)
          data[match[:asset]]
        else
          data
        end
      end

      def instantiate(data)
        path.readlines.map{|l|
          next if l =~ context_rgx
          Dialect.render(l, data) rescue l
        }.compact.join("")
      end

    end # class Full
  end # class File
end # module Jeny
