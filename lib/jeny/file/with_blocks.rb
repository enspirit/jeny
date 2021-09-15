module Jeny
  class File
    class WithBlocks < File

      def has_jeny_blocks?
        !jeny_blocks.empty?
      rescue Exception => ex
        puts "WARN: #{path} skipped: #{ex.message}"
        false
      end

      def jeny_blocks
        @jeny_blocks ||= _parse_jeny_blocks(path.readlines, 0, [])
      end

      def instantiate(data)
        return path.read unless has_jeny_blocks?
        _instantiate(data, path.readlines, 0, jeny_blocks, []).join("")
      end

    private

      def _parse_jeny_blocks(lines, index, blocks)
        if index >= lines.size
          blocks
        elsif match = (lines[index].match(jeny_block_regex))
          source, new_index = _parse_jeny_block(lines, index)
          blocks << CodeBlock.new(source, path, index+1, match[:asset])
          _parse_jeny_blocks(lines, new_index+1, blocks)
        else
          _parse_jeny_blocks(lines, index+1, blocks)
        end
      end

      def _parse_jeny_block(lines, index, str = "")
        if lines[index] =~ jeny_block_regex
          _parse_jeny_block(lines, index+1, str + lines[index])
        else
          source = str.split("\n").map{|s|
            s.gsub(jeny_block_gsub, "")
          }
          source = source.size == 1 ? source.first : source.join("\n")+"\n"
          [source, index]
        end
      end

      def _instantiate(data, lines, index, blocks, acc)
        block = blocks.first
        if block.nil?
          lines[index..-1].each{|l| acc << l }
          acc
        elsif block.line_index == index
          if i = block.instantiate(data)
            acc << i << "\n"
          end
          acc << lines[index]
          _instantiate(data, lines, index+1, blocks[1..-1], acc)
        else
          lines[index...block.line_index].each{|l| acc << l }
          _instantiate(data, lines, block.line_index, blocks, acc)
        end
      end

      def jeny_block_regex
        @jeny_block_regex ||= %r{^\s*#{config.jeny_block_delimiter}\((?<asset>[a-z]+)\)}m
      end

      def jeny_block_gsub
        @jeny_block_gsub ||= %r{#{config.jeny_block_delimiter}(\([a-z]+\))[ ]?}
      end

    end # class WithBlocks
  end # class File
end # module Jeny
