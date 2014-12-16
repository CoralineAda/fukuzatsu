module Fukuzatsu

  module Formatters

    module Base

      def self.included(klass)
        klass.send(:attr_accessor, :summary)
        klass.send(:attr_accessor, :source)
        klass.send(:attr_accessor, :base_output_path)
        klass.extend(ClassMethods)
      end

      def initialize(source: nil, summary:nil, base_output_path:)
        self.source = source
        self.summary = summary
        self.base_output_path = base_output_path
      end

      def export
        begin
          File.open(path_to_results, 'w') {|outfile| outfile.write(content)}
        rescue Exception => e
          puts "Unable to write output to #{path_to_results}: #{e} #{e.backtrace}"
        end
      end

      def filename
        File.basename(self.summary.source_file) + file_extension
      end

      def output_directory
        self.base_output_path + "/" + file_extension.gsub(".","")
      end

      def output_path
        if self.summary
          output_path = output_directory + "/" + File.dirname(self.summary.source_file)
          FileUtils.mkpath(output_path)
        else
          output_path = File.dirname(output_directory)
        end
        output_path
      end

      def path_to_results
        File.join(output_path, filename)
      end

      module ClassMethods

        def index(summaries, base_output_path)
        end

        def reset_output_directory(base_output_path)
          directory = new(base_output_path: base_output_path).output_directory
          begin
            FileUtils.remove_dir(directory)
          rescue Errno::ENOENT
          FileUtils.mkpath(directory)
        end

        def writes_to_file_system?
          true
        end

      end
    end

  end

end
