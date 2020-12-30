module Jeny
  class StateManager
    # StateManager implementation that uses git to manage state management.
    #
    # This state management requires executing jeny in the git root folder.
    class Git < StateManager

      # Executes a `git stash`
      def stash(state)
        system("git diff --exit-code")
        state.stashed = ($?.exitstatus != 0)
        system("git stash") if state.stashed
      end

      # Executes a `git stash pop`
      def unstash(state)
        system("git stash pop") if state.stashed
      end

      # Reset all changes through a `git reset --hard`.
      #
      # WARN: changes not related to `changed` are reverted too,
      # which should be nothing since a stash has been done before.
      def reset(changed, state)
        changed.each{|f| f.rm_rf if f.exists? }
        system("git reset --hard")
      end

      # Commits all changes, using `git add` the `git commit`
      def commit(changed, state)
        return if changed.empty?
        system("git add #{changed.join(" ")}")
        msg = "jeny #{$*.join(' ')}"
        system("git commit -m '#{msg}'")
      end

    end # class Git
  end # class StateManager
end # module Jeny