module Fukuzatsu
  class FileReader

    attr_reader :paths_to_files

    def initialize(paths_to_files)
      @paths_to_files = paths_to_files
    end

    def source_files
      file_list.map{ |file_path| SourceFile.new(file_path) }
    end

    private

    def file_list
      paths_to_files.map do |path|
        if File.directory?(path)
          Dir.glob(File.join(path, "**", "*.rb"))
        else
          path
        end
      end.flatten
    end

    class SourceFile
      attr_reader :filename

      def initialize(filename)
        @filename = filename
      end

      def contents
        File.read(filename)
      end
    end

  end
end
