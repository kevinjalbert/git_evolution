module GitEvolution
  class Commit
    attr_reader :sha, :author, :date, :subject, :body, :additions, :deletions

    def initialize(raw_commit)
      @sha = raw_commit.scan(/^commit\s+(.*?)$/).flatten.first.strip
      @author = raw_commit.scan(/^Author:\s+(.*?)$/).flatten.first.strip
      @date= raw_commit.scan(/^Date:\s+(.*?)$/).flatten.first.strip

      raw_body_lines = raw_commit.scan(/^Date:.*?$(.*?)^diff/m).flatten.first.strip.split("\n")
      @subject = raw_body_lines.first.strip

      if raw_body_lines.size > 1
        @body = raw_body_lines[1..-1].map { |line| line.gsub(/^\s+/, '') }.join("\n")
        @body.sub!(/\n+/, '') if @body.start_with?("\n")
      end

      raw_diff_lines = raw_commit.scan(/^@@.*?$(.*)?/m).flatten.first.strip.split("\n")
      @additions = raw_diff_lines.count { |line| line.start_with?('+') }
      @deletions = raw_diff_lines.count { |line| line.start_with?('-') }
    end
  end
end
