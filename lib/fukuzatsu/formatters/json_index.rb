module Fukuzatsu

  module Formatters

    class JsonIndex

      include Formatters::Base

      attr_reader :summaries

      def initialize(summaries, base_output_path)
        @summaries = summaries
        @base_output_path = base_output_path
      end

      def content
        summaries.map { |summary| Json.new(summary: summary, base_output_path: self.base_output_path).as_json }.to_json
      end

      def filename
        "json/results.json"
      end

      def file_extension
        ".json"
      end

    end

  end

end
