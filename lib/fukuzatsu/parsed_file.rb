class ParsedFile

  include PoroPlus
  include Ephemeral::Base
  collects :parsed_methods

  attr_accessor :path_to_file, :class_name

  def class_name
    @class_name ||= "FIXME"
  end

  def content
    File.open(path_to_file, "r").read
  end

  def complexity
    @complexity ||= Analyzer.parse!(content)
  end

end