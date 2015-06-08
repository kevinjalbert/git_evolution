module GitEvolution
  class Repository
    def initialize(directory_name)
      @git_repo = Rugged::Repository.discover(File.expand_path(directory_name))
    end

    def dir
      @git_repo.workdir
    end

    def commit(sha)
      Commit.new(self, sha)
    end

    def commits(shas)
      shas.map { |sha| commit(sha) }
    end

    def line_commits(start_line, end_line, file, since = nil)
      results = line_history(start_line, end_line, file, since)
      commit_shas = results.scan(/^commit ([0-9a-f]{40})/).flatten
      commits(commit_shas)
    end

    def line_history(start_line, end_line, file, since = nil)
      since_option = "--since '#{since}'"

      Dir.chdir(dir) do
        return `git --no-pager log #{since_option if since} -L#{start_line},#{end_line}:#{file} --follow #{file}`
      end
    end
  end
end
