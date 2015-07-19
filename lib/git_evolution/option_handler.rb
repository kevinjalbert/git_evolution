module GitEvolution
  module OptionHandler
    def self.parse_options(args)
      options = OpenStruct.new(
        range: nil,
        since: nil,
        start_line: nil,
        end_line: nil,
      )

      OptionParser.new do |opts|
        opts.banner = 'Usage: git_evolution [options] <file>'
        opts.version = VERSION
        opts.on '-r', '--range N:N', String, 'The specified range of lines to consider within the file (optional)' do |value|
          options.range = value
        end
        opts.on '-s', '--since STRING', String, 'Consider the commits which are more recent than the specified time (optional)' do |value|
          options.since = value
        end
      end.parse!

      options[:file] = args[0]
      options[:start_line], options[:end_line] = parse_range(options[:range])

      validate_options!(options)

      options
    end

    def self.parse_range(range)
      return if range.nil?

      regex_matches = range.match(/^(\d+):(\d+)/)
      raise 'The --range option was not in the valid format (N:N)' if regex_matches.nil?

      start_line = regex_matches[1].to_i
      end_line = regex_matches[2].to_i

      return start_line, end_line
    end

    def self.validate_options!(options)
      if options.file.nil?
        raise 'Missing required file argument'
      elsif !File.exist?(options.file)
        raise "File #{options.file} does not exist"
      end

      if !options.range.nil?
        raise 'Start line cannot be greater than the end line' if options.start_line > options.end_line

        file_length = File.new(options.file).readlines.size
        raise "End line cannot be larger than the length of the file (#{file_length})" if options.end_line > file_length
      end

      if !options.since.nil?
        options.since = Chronic.parse(options.since)
        raise 'The since time could not be properly parsed' if options.since.nil?
      end
    end
  end
end
