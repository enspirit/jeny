module Jeny
  class Configuration

    DEFAULT_EDIT_PROC = ->(_,content) {
      content =~ /TODO/
    }

    def initialize
      @jeny_block_delimiter = "#jeny"
      @ignore_pattern = /^(vendor|\.bundle)/
      @editor_command = default_editor_command
      @edit_changed_files = DEFAULT_EDIT_PROC
      @state_manager = default_state_manager
      @state_manager_options = {
        stash: true,
        commit: true
      }
      yield(self) if block_given?
    end
    attr_accessor :jeny_file

    # The delimiter used for jeny block in source code files.
    #
    # Defaults to `#jeny`
    attr_accessor :jeny_block_delimiter

    # Regular expression matching files that can always be ignored by Snippets.
    #
    # Defaults to /^(vendor|\.bundle)/
    attr_accessor :ignore_pattern

    # Shell command to open the source code editor.
    #
    # Default value checks the JENY_EDITOR, GIT_EDITOR, EDITOR
    # environment variables, and fallbacks to "code".
    attr_accessor :editor_command

    def default_editor_command
      ENV['JENY_EDITOR'] || ENV['GIT_EDITOR'] || ENV['EDITOR']
    end

    # State manager to use.
    #
    # Default value check the JENY_STATE_MANAGER environment variable:
    # - `none`, no state management is done
    # - `git`, git is used to stash/unstash/commit/reset
    #
    # Defaults to `none`, that is, to an empty state manager.
    attr_reader :state_manager

    # Options for the state manager.
    #
    # This is a Hash, with `:stash` and `:commit` keys mapping to
    # either true of false.
    #
    # Both are true by default.
    attr_reader :state_manager_options

    # :nodoc:
    def sm_stash?
      state_manager_options[:stash]
    end

    # :nodoc:
    def sm_commit?
      state_manager_options[:commit]
    end

    # Sets the state manager to use. `sm` can be a state manager instance,
    # of a string of symbol with same value as JENY_STATE_MANAGER env
    # variable.
    def state_manager=(sm)
      @state_manager = case sm
      when StateManager then sm
      when :git, "git"  then StateManager::Git.new(self)
      else StateManager.new(self)
      end
    end

    def default_state_manager
      case ENV['JENY_STATE_MANAGER']
      when "git"
        StateManager::Git.new(self)
      else
        StateManager.new(self)
      end
    end

    # Whether files generated/modified must be edited right after.
    #
    # Accepted values are:
    # - `false`, then source code edition is disabled
    # - `true`, then all files are open after being snipetted
    # - `/.../`, then only files whose name match the regexp are open
    # - `->(f,c){}`, the file `f` whose generated content is `c` is open
    #   is the proc returns a truthy value.
    #
    # Defaults to a Proc that opens files having at least one TODO.
    attr_accessor :edit_changed_files

    alias :edit_changed_files? :edit_changed_files

    # Should `file` be ignored?
    def ignore_file?(file)
      file = Command::Support.simplify_path(file)
      file.to_s =~ ignore_pattern
    end

    # Whether file should be edited after being snippetted
    def should_be_edited?(file, content)
      return false if editor_command.nil?
      case edit_changed_files
      when false, true, nil
        !!edit_changed_files
      when Regexp
        !!(file.to_s =~ edit_changed_files)
      when Proc
        !!edit_changed_files.call(file, content)
      else
        raise Error, "Wrong edit_changed_files `#{edit_changed_files}`"
      end
    end

    def open_editor(files)
      unless editor_command
        raise Error, "source code editor is not enabled"
      end
      fork{ exec(editor_command + " " + files.join(" ")) }
    end

  end # class Configuration
end # module Jeny
