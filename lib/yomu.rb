require 'yomu/version'

require 'net/http'
require 'yaml'

class Yomu
  GEMPATH = File.dirname(File.dirname(__FILE__))
  JARPATH = File.join(Yomu::GEMPATH, 'jar', 'tika-app-1.1.jar')

  # Read text or metadata from a data buffer.
  #
  #   data = File.read 'sample.pages'
  #   text = Yomu.read :text, data
  #   metadata = Yomu.read :metadata, data

  def self.read(type, data)
    switch = case type
    when :text
      '-t'
    when :metadata
      '-m'
    end

    result = IO.popen "java -Djava.awt.headless=true -jar #{Yomu::JARPATH} #{switch}", 'r+' do |io|
      io.write data
      io.close_write
      io.read
    end

    type == :metadata ? YAML.load(result) : result
  end

  # Create a new instance of Yomu.
  #
  # Using a file path:
  #
  #   Yomu.new 'sample.pages'
  #
  # Using a URL:
  #
  #   Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'
  #
  # Using a stream or object which responds to +read+
  #
  #   Yomu.new File.open('sample.pages')

  def initialize(input)
    if input.is_a? String
      if input =~ URI::regexp
        @uri = URI.parse input
      elsif File.exists? input
        @path = input
      else
        raise Errno::ENOENT.new "missing file or invalid URI - #{input}"
      end
    elsif input.respond_to? :read
      @stream = input
    else
      raise TypeError.new "can't read from #{input.class.name}"
    end
  end

  # Returns the text contents of a Yomu object.
  #
  #   yomu = Yomu.new 'sample.pages'
  #   yomu.text

  def text
    return @text if defined? @text

    @text = Yomu.read :text, data
  end

  # Returns the metadata hash of a Yomu object.
  #
  #   yomu = Yomu.new 'sample.pages'
  #   yomu.metadata['Content-Type']
  
  def metadata
    return @metadata if defined? @metadata

    @metadata = Yomu.read :metadata, data
  end

  def path?
    defined? @path
  end

  def uri?
    defined? @uri
  end

  def stream?
    defined? @stream
  end

  protected

  def data
    return @data if defined? @data

    if path?
      @data = File.read @path
    elsif uri?
      @data = Net::HTTP.get @uri
    elsif stream?
      @data = @stream.read
    end

    @data
  end
end