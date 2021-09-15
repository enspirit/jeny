module Jeny
  class CodeBlock

    def initialize(source, path, line, asset)
      @source = source
      @path = path
      @line = line
      @asset = asset
    end
    attr_reader :source, :path, :line, :asset

    def line_index
      line - 1
    end

    def instantiate(data)
      case d = data[asset]
      when NilClass
      when Hash
        Dialect.render(source, d) rescue source
      when Array
        d.map{|item| instantiate(asset => item) }.join("\n")  
      else
        raise Error, "Unexpected block asset: `#{asset} = #{d}`"
      end
    end

  end # class CodeBlock
end # module Jeny
