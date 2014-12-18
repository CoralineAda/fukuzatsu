module Fukuzatsu

  module Formatters

    class JsonStdout

      include Formatters::Base

      attr_reader :summaries

      def self.reset_output_directory(base_output_path)
      end

      def self.no_stdout?
        true
      end

      def self.index(summaries, base_output_path)
        puts summaries.map { |summary| Json.new(summary: summary, base_output_path: base_output_path).as_json }.to_json
      end

      def export
      end

    end
  end
end
