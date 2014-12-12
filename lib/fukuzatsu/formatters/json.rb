module Fukuzatsu

  module Formatters

    class Json

      include Formatters::Base

      def self.index(summaries, base_output_path)
        Fukuzatsu::Formatters::JsonIndex.new(summaries, base_output_path).export
      end

      def as_json
        result = {
          source_file: summary.source_file,
          object: summary.container_name,
          name: summary.entity_name,
          complexity: summary.complexity
        }
        if summary.is_class_or_module?
          result[:average_complexity] = summary.average_complexity
          result[:methods] = summary.summaries.map { |s| Json.new(summary: s, base_output_path: self.base_output_path).as_json }
        end
        result
      end

      def content
        as_json.to_json
      end

      def file_extension
        ".json"
      end
    end

  end
end