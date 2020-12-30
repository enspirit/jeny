module Jeny
  # State Manager abstraction used by Snippets to work atomically.
  #
  # An implementation is supposed to be stateless (no instance
  # variables). The methods receive a `state` argument, which is
  # an OpenStruct that can be used to track state accros calls.
  #
  # See StateManager::Git for a typical implementation using git.
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
    def stash(state)
    end

    # Unstash changes stashed the last time `stash` has been called.
    #
    # This method MAY NOT raise errors since a previous `stash`
    # has been successfuly done earlier.
    #
    # The method SHOULD NOT raise an Error is nothing needs to be done.
    def unstash(state)
    end

    # Reset all changes to files in `changed`, typically because an error
    # occured.
    #
    # The method SHOULD NOT raise an Error in any case.
    def reset(changed, state)
    end

    # Commit all changes to the files in `changed`.
    #
    # The method MAY raise an Error, but it will force jeny to reset
    # everything.
    def commit(changed, state)
    end

  end # class StateManage
end # module Jeny
require_relative 'state_manager/git'
