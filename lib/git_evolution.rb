require_relative './git_evolution/initialize.rb'

module GitEvolution
  def self.run(args)
    start_line = args[0]
    end_line = args[1]
    file = args[2]

    repo = Repository.new(File.dirname(File.expand_path(file)))
    commits = repo.line_commits(start_line, end_line, file)

    ReportPresenter.new(commits).print
  end
end
