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
      # WARN: changes not related to `changed` are reverted too,
      # which should be nothing since a stash has been done before.
      def reset(changed)
        changed.each{|f| f.rm_rf if f.exists? }
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