module GitEvolution
  class ReportPresenter
    def initialize(commits)
      @commits = commits
      @ownership = Hash.new(0)
    end

    def print
      print_commits
      puts '-' * 80
      puts
      print_ownership
    end

    def print_commits
      puts 'Commits:'
      @commits.each do |commit|
        puts "#{commit.author} (#{Time.at(commit.date.to_i)}) - #{commit.sha}"
        puts "#{commit.title}"
        puts

        @ownership[commit.author] = @ownership[commit.author] + 1
      end
    end

    def print_ownership
      puts 'Ownership:'
      @ownership.each do |author, count|
        puts "#{author} - #{count}/#{@commits.size} (#{(count.to_f / @commits.size * 100).round(2)}%)"
      end
    end
  end
end
