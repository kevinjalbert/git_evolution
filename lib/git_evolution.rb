require_relative './git_evolution/initialize.rb'

module GitEvolution
  def self.run(args)
    options = OptionHandler.parse_options(args)

    repo = Repository.new(options.file)
    commits = repo.line_commits(options.start_line, options.end_line, options.file, options.since)

    ReportPresenter.new(commits).print
  rescue StandardError => e
    puts "[#{e.class}] #{e.message}"
    puts e.backtrace
  end
end
