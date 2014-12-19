require 'fileutils'
require 'analyst'

module Fukuzatsu

  class Parser

    attr_reader :path_to_files, :formatter, :threshold, :output_path

    DEFAULT_OUTPUT_DIRECTORY = "doc/fukuzatsu/"

    def initialize(path_to_files, formatter, threshold, output_path=nil)
      @path_to_files = path_to_files
      @formatter = formatter
      @threshold = threshold
      @output_path = output_path || DEFAULT_OUTPUT_DIRECTORY
    end

    def explain
      puts "Processed #{summaries.count} file(s)."
      puts "Results written to #{output_path}." if formatter.writes_to_file_system?
    end

    def report
      self.formatter.reset_output_directory(output_path)
      self.formatter.index(summaries, output_path)
      summaries.uniq(&:container_name).each do |summary|
        self.formatter.new(summary: summary, base_output_path: self.output_path).export
      end
      unless self.formatter.no_stdout?
        explain
        check_complexity
      end
    end

    private

    def check_complexity
      return if self.threshold == 0
      return unless complexity_exceeds_threshold?
      puts "Maximum average complexity of #{average_complexities.max} exceeds #{self.threshold.to_f} threshold!"
      exit 1
    end

    def average_complexities
      average_complexities ||= summaries.map(&:average_complexity)
    end

    def complexity_exceeds_threshold?
      average_complexities.max.to_f > self.threshold.to_f
    end

    def summaries
      @summaries ||= file_reader.source_files.map do |source_file|
        Fukuzatsu::Summary.from(
          content: source_file.contents,
          source_file: source_file.filename
        )
      end.flatten
    end

    def file_reader
      @file_reader ||= Fukuzatsu::FileReader.new(self.path_to_files)
    end

  end

end
