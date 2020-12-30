module Jeny
  class File
    class Full < File

      def context_rgx
        /^#{config.jeny_block_delimiter}ctx\s+([a-z]+)\s*$/
      end

      def has_jeny_context?
        path.readlines.first =~ context_rgx
      end

      def instantiate_context(data)
        if path.readlines.first =~ context_rgx
          data[$1]
        else
          data
        end
      end

      def instantiate(data)
        path.readlines.map{|l|
          next if l =~ context_rgx
          Dialect.render(l, data)
        }.compact.join("")
      end

    end # class Full
  end # class File
end # module Jeny
