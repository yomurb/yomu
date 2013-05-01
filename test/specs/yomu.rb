require_relative '../helper.rb'

describe Yomu do
  let(:data) { File.read 'test/samples/sample.docx' }

  before do
    ENV['JAVA_HOME'] = nil
  end

  describe '.read' do
    it 'reads text' do
      text = Yomu.read :text, data

      assert_includes text, 'The quick brown fox jumped over the lazy cat.'
    end

    it 'reads metadata' do
      metadata = Yomu.read :metadata, data

      assert_equal 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', metadata['Content-Type']
    end

    it 'accepts metadata with colon' do
      doc = File.read 'test/samples/enclosure_problem.doc'
      metadata = Yomu.read :metadata, doc

      assert_equal 'problem: test', metadata['dc:title']
    end

    it 'reads mimetype' do
      mimetype = Yomu.read :mimetype, data

      assert_equal 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', mimetype.content_type
      assert_includes mimetype.extensions, 'docx'
    end
  end

  describe '.new' do
    it 'requires parameters' do
      assert_raises ArgumentError do
        Yomu.new
      end
    end

    it 'accepts a root path' do
      yomu = nil

      assert_silent do
        yomu = Yomu.new 'test/samples/sample.pages'
      end

      assert yomu.path?
      refute yomu.uri?
      refute yomu.stream?
    end

    it 'accepts a relative path' do
      yomu = nil

      assert_silent do
        yomu = Yomu.new 'test/samples/sample.pages'
      end

      assert yomu.path?
      refute yomu.uri?
      refute yomu.stream?
    end

    it 'accepts a path with spaces' do
      yomu = nil

      assert_silent do
        yomu = Yomu.new 'test/samples/sample filename with spaces.pages'
      end

      assert yomu.path?
      refute yomu.uri?
      refute yomu.stream?
    end

    it 'accepts a URI' do
      yomu = nil

      assert_silent do
        yomu = Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'
      end

      assert yomu.uri?
      refute yomu.path?
      refute yomu.stream?
    end

    it 'accepts a stream or object that can be read' do
      yomu = nil

      assert_silent do
        File.open 'test/samples/sample.pages', 'r' do |file|
          yomu = Yomu.new file
        end
      end

      assert yomu.stream?
      refute yomu.path?
      refute yomu.uri?
    end

    it 'does not accept a path to a missing file' do
      assert_raises Errno::ENOENT do
        Yomu.new 'test/sample/missing.pages'
      end
    end

    it 'does not accept other objects' do
      [nil, 1, 1.1].each do |object|
        assert_raises TypeError do
          Yomu.new object
        end
      end
    end
  end

  describe '.java' do
    specify 'with no specified JAVA_HOME' do
      assert_equal 'java', Yomu.send(:java)
    end

    specify 'with a specified JAVA_HOME' do
      ENV['JAVA_HOME'] = '/path/to/java/home'

      assert_equal '/path/to/java/home/bin/java', Yomu.send(:java)
    end
  end

  describe 'initialized with a given path' do
    let(:yomu) { Yomu.new 'test/samples/sample.pages' }

    specify '#text reads text' do
      assert_includes yomu.text, 'The quick brown fox jumped over the lazy cat.'
    end

    specify '#metada reads metadata' do
      assert_equal 'application/vnd.apple.pages', yomu.metadata['Content-Type']
    end
  end

  describe 'initialized with a given URI' do
    let(:yomu) { Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx' }

    specify '#text reads text' do
      assert_includes yomu.text, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'
    end

    specify '#metadata reads metadata' do
      assert_equal 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', yomu.metadata['Content-Type']
    end
  end

  describe 'initialized with a given stream' do
    let(:yomu) { Yomu.new File.open('test/samples/sample.pages', 'rb') }

    specify '#text reads text' do
      assert_includes yomu.text, 'The quick brown fox jumped over the lazy cat.'
    end

    specify '#metadata reads metadata' do
      assert_equal 'application/vnd.apple.pages', yomu.metadata['Content-Type']
    end
  end
end
