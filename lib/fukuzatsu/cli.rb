require 'thor'
require 'fukuzatsu'

module Fukuzatsu

  class CLI < Thor

    desc "check [-f FORMAT] [-t MAX_COMPLEXITY_ALLOWED] PATHS_TO_FILES...", "Run complexity analysis on PATHS_TO_FILES..."
    long_desc <<-LONGDESC
      `PATHS_TO_FILES...` is a list of files to analyze. Can specify directories
      and/or files. For directories, all *.rb files found in the directory tree
      get included. Wildcards (e.g. `*`) are not currently supported.\r\n\r\n
      Example: fuku check -f html app/models app/services
    LONGDESC

    method_option :format, :type => :string, :default => 'text', :aliases => "-f", :desc => "Output format; text, csv, json, or html"
    method_option :threshold, :type => :numeric, :default => 0, :aliases => "-t", :desc => "Maximum allowed complexity. If the complexity of any file exceeds this value, the exit status will be non-zero (failure)."
    method_option :output, :type => :string, :aliases => "-o", :desc => "Path to output directory."

    def check(path, *more_paths)
      paths = [path] + more_paths
      Fukuzatsu.new(paths, formatter, options['threshold'], options['output']).report
    end

    private

    def formatter
      options['format'] && options['format'].to_sym || :text
    end

  end

end
