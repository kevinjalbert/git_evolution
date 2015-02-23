require_relative './git_evolution/initialize.rb'

module GitEvolution
  def self.run(args)
    start_line = args[0]
    end_line = args[1]
    file = args[2]

    repo = Repository.new(File.dirname(File.expand_path(file)))

    results = repo.line_history(start_line, end_line, file)

    commit_shas = results.scan(/^commit ([0-9a-f]{40})/)
    commit_shas = commit_shas.flatten

    commit_info = {}
    commit_shas.each do |sha|
      commit = `git --no-pager show -s --format=%an%n%n%at%n%n%s%n%n%b #{sha}`
      commit_data = commit.split("\n\n")
      commit_info[sha] = {
        author: commit_data[0],
        date: commit_data[1],
        title: commit_data[2],
        body: commit_data[3..-1].join
      }
    end

    ownership = Hash.new(0)

    puts 'Commits:'
    commit_info.each do |sha, data|
      puts "#{data[:author]} (#{Time.at(data[:date].to_i)}) - #{sha}"
      puts "#{data[:title]}"
      puts

      ownership[data[:author]] = ownership[data[:author]] + 1
    end

    puts '-' * 80

    puts
    puts 'Ownership:'
    ownership.each do |author, count|
      puts "#{author} - #{count}/#{commit_info.size} (#{(count.to_f / commit_info.size * 100).round(2)}%)"
    end
  end
end
