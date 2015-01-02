require 'json'
require 'fileutils'
require 'haml'
require 'analyst'

require_relative "fukuzatsu/file_reader"
require_relative "fukuzatsu/formatters/base"
require_relative "fukuzatsu/formatters/csv"
require_relative "fukuzatsu/formatters/html"
require_relative "fukuzatsu/formatters/html_index"
require_relative "fukuzatsu/formatters/json"
require_relative "fukuzatsu/formatters/json_index"
require_relative "fukuzatsu/formatters/json_stdout"
require_relative "fukuzatsu/formatters/text"
require_relative "fukuzatsu/parser"
require_relative "fukuzatsu/summary"
require_relative "fukuzatsu/version"

module Fukuzatsu
  def self.new(paths_to_files, formatter=:text, threshold=0, output_path=nil)
    Fukuzatsu::Parser.new(paths_to_files, formatters[formatter], threshold, output_path)
  end

  def self.formatters
    {
      html: Fukuzatsu::Formatters::Html,
      csv:  Fukuzatsu::Formatters::Csv,
      json:  Fukuzatsu::Formatters::Json,
      json_stdout: Fukuzatsu::Formatters::JsonStdout,
      text: Fukuzatsu::Formatters::Text
    }
  end
end
