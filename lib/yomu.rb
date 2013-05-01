require 'yomu/version'

require 'net/http'
require 'mime/types'
require 'yaml'

class Yomu
  GEMPATH = File.dirname(File.dirname(__FILE__))
  JARPATH = File.join(Yomu::GEMPATH, 'jar', 'tika-app-1.3.jar')

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
    when :mimetype
      '-m'
    end

    result = IO.popen "#{java} -Djava.awt.headless=true -jar #{Yomu::JARPATH} #{switch}", 'r+' do |io|
      io.write data
      io.close_write
      io.read
    end

    case type
    when :text
      result
    when :metadata
      YAML.load enclose_metadata_fields(result)
    when :mimetype
      MIME::Types[YAML.load(enclose_metadata_fields(result))['Content-Type']].first
    end
  end

  # Create a new instance of Yomu with a given document.
  #
  # Using a file path:
  #
  #   Yomu.new 'sample.pages'
  #
  # Using a URL:
  #
  #   Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'
  #
  # From a stream or an object which responds to +read+
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

  # Returns the text content of the Yomu document.
  #
  #   yomu = Yomu.new 'sample.pages'
  #   yomu.text

  def text
    return @text if defined? @text

    @text = Yomu.read :text, data
  end

  # Returns the metadata hash of the Yomu document.
  #
  #   yomu = Yomu.new 'sample.pages'
  #   yomu.metadata['Content-Type']

  def metadata
    return @metadata if defined? @metadata

    @metadata = Yomu.read :metadata, data
  end

  # Returns the mimetype object of the Yomu document.
  #
  #   yomu = Yomu.new 'sample.docx'
  #   yomu.mimetype.content_type #=> 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
  #   yomu.mimetype.extensions #=> ['docx']

  def mimetype
    return @mimetype if defined? @mimetype

    @mimetype = MIME::Types[metadata['Content-Type']].first
  end

  # Returns +true+ if the Yomu document was specified using a file path.
  #
  #   yomu = Yomu.new 'sample.pages'
  #   yomu.path? #=> true

  def path?
    defined? @path
  end

  # Returns +true+ if the Yomu document was specified using a URI.
  #
  #   yomu = Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'
  #   yomu.uri? #=> true

  def uri?
    defined? @uri
  end

  # Returns +true+ if the Yomu document was specified from a stream or an object which responds to +read+.
  #
  #   file = File.open('sample.pages')
  #   yomu = Yomu.new file
  #   yomu.stream? #=> true

  def stream?
    defined? @stream
  end

  # Returns the raw/unparsed content of the Yomu document.
  #
  #   yomu = Yomu.new 'sample.pages'
  #   yomu.data

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

  def self.enclose_metadata_fields metadata
    metadata.each_line.map do |l|
      l.gsub(/: (.*)/,': "\1"')
    end.join
  end

  def self.java
    ENV['JAVA_HOME'] ? ENV['JAVA_HOME'] + '/bin/java' : 'java'
  end
  private_class_method :java
end
