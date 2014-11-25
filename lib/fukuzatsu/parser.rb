require 'fileutils'
require 'analyst'

module Fukuzatsu

  class Parser

    attr_reader :path_to_files, :formatter, :threshold

    def initialize(path_to_files, formatter, threshold)
      @path_to_files = path_to_files
      @formatter = formatter
      @threshold = threshold
    end

    def report
      self.formatter.report
      self.formatter.reset_output_directory
      self.formatter.index(summaries)
      summaries.uniq(&:container_name).each do |summary|
        self.formatter.new(summary: summary).export
      end
      self.formatter.explain(summaries.count)
      check_complexity
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
