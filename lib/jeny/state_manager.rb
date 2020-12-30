module Jeny
  class StateManager

    def initialize(config)
      @config = config
    end
    attr_reader :config

    # Make sure the working directory is clean, for instance by stashing
    # any pending change.
    #
    # The method MAY raise an Error if the current state is not clean and
    # nothing can be done about it.
    #
    # The method SHOULD NOT raise an Error is nothing needs to be done.
    def stash
    end

    # Unstash changes stashed the last time `stash` has been called.
    #
    # This method MAY NOT raise errors since a previous `stash`
    # has been successfuly done earlier.
    #
    # The method SHOULD NOT raise an Error is nothing needs to be done.
    def unstash
    end

    # Reset all changes to files in `changed`, typically because an error
    # occured.
    #
    # The method SHOULD NOT raise an Error in any case.
    def reset(changed)
    end

    # Commit all changes to the files in `changed`.
    #
    # The method MAY raise an Error, but it will force jeny to reset
    # everything.
    def commit(changed)
    end

  end # class StateManage
end # module Jeny
require_relative 'state_manager/git'
