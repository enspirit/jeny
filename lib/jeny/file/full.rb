module Jeny
  class File
    class Full < File

      def instantiate(data)
        path.readlines.map{|l|
          Dialect.render(l, data)
        }.join("")
      end

    end # class Full
  end # class File
end # module Jeny
