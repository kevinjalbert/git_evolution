module GitEvolution
  class Commit
    attr_reader :raw_commit, :sha, :author, :date, :subject, :body, :additions, :deletions

    def initialize(raw_commit)
      @raw_commit = raw_commit

      parse_meta_data!
      parse_body_data!
      parse_diff_data!
    end

    def parse_meta_data!
      @sha = raw_commit.scan(/^commit\s+(.*?)$/).flatten.first.strip
      @author = raw_commit.scan(/^Author:\s+(.*?)$/).flatten.first.strip
      @date= raw_commit.scan(/^Date:\s+(.*?)$/).flatten.first.strip
    end

    def parse_body_data!
      raw_body_lines = (raw_commit + "\n\u0000").scan(/^Date:.*?$(.*?)^[diff|\u0000]/m).flatten.first.strip.split("\n")
      @subject = raw_body_lines.first.strip

      if raw_body_lines.size > 1
        @body = raw_body_lines[1..-1].map { |line| line.gsub(/^\s+/, '') }.join("\n")
        @body.sub!(/\n+/, '') if @body.start_with?("\n")
      end
    end

    def parse_diff_data!
      raw_diff_lines = raw_commit.scan(/^@@.*?$(.*)?/m).flatten.first

      if raw_diff_lines
        raw_diff_lines = raw_diff_lines.strip.split("\n")
        @additions = raw_diff_lines.count { |line| line.start_with?('+') }
        @deletions = raw_diff_lines.count { |line| line.start_with?('-') }
      else
        @additions = 0
        @deletions = 0
      end
    end
  end
end
