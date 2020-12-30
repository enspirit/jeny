module Jeny
  class StateManager
    # StateManager implementation that uses git to manage state management.
    #
    # This state management requires executing jeny in the git root folder.
    class Git < StateManager

      # Executes a `git stash`
      def stash
        system("git stash")
      end

      # Executes a `git stash pop`
      def unstash
        system("git stash pop")
      end

      # Reset all changes through a `git reset --hard`.
      #
      # WARN: changed is ignored, since stash has been called before.
      def reset(changed)
        system("git reset --hard")
      end

      # Commits all changes, using `git add` the `git commit`
      def commit(changed)
        system("git add #{changed.join(" ")}")
        msg = "jeny #{$*.join(' ')}"
        system("git commit -m '#{msg}'")
      end

    end # class Git
  end # class StateManager
end # module Jeny