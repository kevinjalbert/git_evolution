module GitEvolution
  class Commit
    attr_reader :sha, :author, :date, :title, :body

    def initialize(repository, sha)
      Dir.chdir(repository.dir) do
        raw_commit = `git --no-pager show -s --format=%an%n%n%at%n%n%s%n%n%b #{sha}`

        commit_data = raw_commit.split("\n\n")
        @author = commit_data[0]
        @date = commit_data[1]
        @title = commit_data[2]
        @body = commit_data[3..-1].join
        @sha = sha
      end
    end
  end
end
