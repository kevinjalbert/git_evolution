module GitEvolution
  class Exception < StandardError; end

  class FileMissingError < GitEvolution::Exception; end
  class InvalidRangeFormatError < GitEvolution::Exception; end
  class FileDoesNotExistError < GitEvolution::Exception; end
  class RangeOutOfBoundsError < GitEvolution::Exception; end
  class TimeParseError < GitEvolution::Exception; end
end
