module GitEvolution
  class Repository
    def initialize(directory_name)
      @git_repo = Rugged::Repository.discover(File.expand_path(directory_name))
    end

    def dir
      @git_repo.workdir
    end

    def line_commits(start_line, end_line, file, since = nil)
      raw_results = raw_line_history(start_line, end_line, file, since)
      raw_results.split("\u0000").map { |raw_commit| Commit.new(raw_commit) }
    end

    def raw_line_history(start_line, end_line, file, since = nil)
      since_option = "--since '#{since}'"
      range_option = "-L#{start_line},#{end_line}:#{file}"
      follow_option = "--follow '#{file}'"

      Dir.chdir(dir) do
        return `git --no-pager log -p -z\
         #{since_option if since}\
         #{start_line && end_line ? range_option : follow_option}`
      end
    end
  end
end
