module GitEvolution
  class ReportPresenter
    def initialize(commits)
      @commits = commits
      @ownership = { commits: Hash.new(0), changes: Hash.new(0) }
    end

    def print
      print_commits
      puts
      puts '-' * 80
      puts
      print_commit_ownership
      puts
      print_changes_ownership
      puts
    end

    def print_commits
      puts 'Commits:'
      @commits.each do |commit|
        puts "#{commit.author} (#{commit.date}) - #{commit.sha}"
        puts "#{commit.subject}"
        puts

        @ownership[:commits][commit.author] = @ownership[:commits][commit.author] + 1
        @ownership[:changes][commit.author] = @ownership[:changes][commit.author] + commit.additions + commit.deletions
      end
    end

    def print_commit_ownership
      puts 'Ownership (Commits):'
      @ownership[:commits].each do |author, count|
        puts "#{author} - #{count}/#{@commits.size} (#{(count.to_f / @commits.size * 100).round(2)}%)"
      end
    end

    def print_changes_ownership
      puts 'Ownership (Changes):'

      total_additions = @commits.inject(0) { |sum, commit| sum + commit.additions }
      total_deletions = @commits.inject(0) { |sum, commit| sum + commit.deletions }
      total_changes = total_additions + total_deletions

      @ownership[:changes].each do |author, count|
        puts "#{author} - #{count}/#{total_changes} (#{(count.to_f / total_changes * 100).round(2)}%)"
      end
    end
  end
end
