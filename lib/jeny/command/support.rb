module Jeny
  class Command
    module Support

      def simplify_path(path)
        if path.to_s.start_with?(Path.pwd.to_s)
          path.relative_to(Path.pwd)
        else
          path
        end
      end
      module_function :simplify_path

      def edit_changed_files(changed)
        to_open = changed
          .select{|pair| config.should_be_edited?(*pair) }
          .map{|pair| simplify_path(pair.first) }
        config.open_editor(to_open) unless to_open.empty?
      end

    end # module Support
  end # class Command
end # module Jeny
