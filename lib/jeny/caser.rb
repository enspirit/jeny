module Jeny
  module Caser

    def self.for_hash(hash)
      hash.each_pair.each_with_object({}) do |(k,v),memo|
        case v
        when String
          Caser.methods(false).each do |m|
            next if m == :for_hash or m == :gen_parts
            memo[Caser.send(m, k)] = Caser.send(m, v)
          end
        when Hash
          memo[k] = for_hash(v)
        when Array
          memo[k] = v.map{|x| for_hash(x) }
        else
          v
        end
      end
    end

    def self.gen_parts(src)
      src.split(/[ -_]/)
    end

    def flat(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.join
    end
    module_function :flat

    def upper(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.map(&:upcase).join(" ")
    end
    module_function :upper

    def upperflat(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.map(&:upcase).join
    end
    module_function :upperflat

    def screaming(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.map(&:upcase).join("_")
    end
    module_function :screaming

    def macro(src)
      screaming(src)
    end
    module_function :macro

    def constant(src)
      screaming(src)
    end
    module_function :constant

    def underscore(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.join("_")
    end
    module_function :underscore

    def snake(src)
      underscore(src)
    end
    module_function :snake

    def camel(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.first + parts[1..-1].map(&:capitalize).join
    end
    module_function :camel

    def pascal(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.map(&:capitalize).join
    end
    module_function :pascal

    def kebab(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.join("-")
    end
    module_function :kebab

    def train(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.map(&:capitalize).join("-")
    end
    module_function :train

    def header(src)
      train(src)
    end
    module_function :header

    def cobol(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.map(&:upcase).join("-")
    end
    module_function :cobol

    def donner(src)
      parts = gen_parts(src) unless src.is_a?(Array)
      parts.join("|")
    end
    module_function :donner

  end # module Caser
end # module Jeny
