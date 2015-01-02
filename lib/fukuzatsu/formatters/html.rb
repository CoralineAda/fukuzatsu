require 'rouge'

module Fukuzatsu

  module Formatters

    class Html

      include Formatters::Base

      def self.index(summaries, base_output_path)
        Fukuzatsu::Formatters::HtmlIndex.new(summaries, base_output_path).export
      end

      def columns
        ["Class", "Method", "Complexity"]
      end

      def content
        Haml::Engine.new(output_template).render(
          Object.new, {
            header: header,
            rows: rows,
            source_lines: preprocessed,
            class_name: summary.container_name,
            average_complexity: sprintf("%0.2f", summary.average_complexity),
            path_to_file: summary.source_file,
            date: Time.now.strftime("%Y/%m/%d"),
            time: Time.now.strftime("%l:%M %P")
          }
        )
      end

      def export
        begin
          File.open(File.expand_path(path_to_results), 'w') {|outfile| outfile.write(content)}
        rescue Exception => e
          puts "Unable to write output: #{e} #{e.backtrace}"
        end
      end

      def file_extension
        ".htm"
      end

      def formatter
        Rouge::Formatters::HTML.new(line_numbers: true)
      end

      def header
        columns.map{|col| "<th>#{col}</th>"}.join("\r\n")
      end

      def lexer
        Rouge::Lexers::Ruby.new
      end

      def output_template
        File.read(File.dirname(__FILE__) + "/templates/output.html.haml")
      end

      def preprocessed
        formatter.format(lexer.lex(summary.raw_source))
      end

      def rows
        i = 0
        summary.summaries.inject([]) do |a, summary|
          i += 1
          a << "<tr class='#{i % 2 == 1 ? 'even' : 'odd'}'>"
          a << "  <td>#{summary.container_name}</td>"
          a << "  <td>#{summary.entity_name}</td>"
          a << "  <td>#{summary.complexity}</td>"
          a << "</tr>"
          a
        end.join("\r\n")
      end

    end

  end
end
