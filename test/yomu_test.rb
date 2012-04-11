require_relative 'test_helper.rb'

require 'yomu.rb'

class YomuTest < MiniTest::Unit::TestCase
  def test_yomu_can_read_text
    data = File.read 'test/samples/sample.pages'
    text = Yomu.read :text, data

    assert_includes text, 'The quick brown fox jumped over the lazy cat.'
  end

  def test_yomu_can_read_metadata
    data = File.read 'test/samples/sample.pages'
    metadata = Yomu.read :metadata, data

    assert_equal 'application/vnd.apple.pages', metadata['Content-Type']
  end

  def test_yomu_cannot_be_initialized_without_parameters
    assert_raises ArgumentError do
      Yomu.new
    end
  end

  def test_yomu_can_be_initialized_with_a_root_path
    assert_silent do
      yomu = Yomu.new File.join(File.dirname(__FILE__), 'samples/sample.pages')

      assert_block { yomu.path? }
      assert_block { !yomu.uri? }
      assert_block { !yomu.stream? }
    end
  end

  def test_yomu_can_be_initialized_with_a_relative_path
    assert_silent do
      yomu = Yomu.new 'test/samples/sample.pages'

      assert_block { yomu.path? }
      assert_block { !yomu.uri? }
      assert_block { !yomu.stream? }
    end
  end

  def test_yomu_can_be_initialized_with_a_path_with_spaces
    assert_silent do
      yomu = Yomu.new 'test/samples/sample filename with spaces.pages'

      assert_block { yomu.path? }
      assert_block { !yomu.uri? }
      assert_block { !yomu.stream? }
    end
  end

  def test_yomu_can_be_initialized_with_a_uri
    assert_silent do
      yomu = Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'

      assert_block { yomu.uri? }
      assert_block { !yomu.path? }
      assert_block { !yomu.stream? }
    end
  end

  def test_yomu_can_be_initialized_with_a_stream_or_object_that_can_be_read
    assert_silent do
      File.open 'test/samples/sample.pages', 'r' do |file|
        yomu = Yomu.new file

      assert_block { yomu.stream? }
      assert_block { !yomu.path? }
      assert_block { !yomu.uri? }
      end
    end
  end

  def test_yomu_cannot_be_initialized_with_a_path_to_a_missing_file
    assert_raises Errno::ENOENT do
      Yomu.new 'test/sample/missing.pages'
    end
  end

  def test_yomu_cannot_be_initialized_with_other_objects
    [nil, 1, 1.1].each do |object|
      assert_raises TypeError do
        Yomu.new object
      end
    end
  end

  def test_yomu_initialized_with_a_path_can_read_text
    yomu = Yomu.new 'test/samples/sample.pages'

    assert_includes yomu.text, 'The quick brown fox jumped over the lazy cat.'
  end

  def test_yomu_initialized_with_a_path_can_read_metadata
    yomu = Yomu.new 'test/samples/sample.pages'

    assert_equal 'application/vnd.apple.pages', yomu.metadata['Content-Type']
  end

  def test_yomu_initialized_with_a_url_can_read_text
    yomu = Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'

    assert_includes yomu.text, 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit.'
  end

  def test_yomu_initialized_with_a_url_can_read_metadata
    yomu = Yomu.new 'http://svn.apache.org/repos/asf/poi/trunk/test-data/document/sample.docx'

    assert_equal 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', yomu.metadata['Content-Type']
  end

  def test_yomu_initialized_with_a_stream_can_read_text
    File.open 'test/samples/sample.pages', 'rb' do |file|
      yomu = Yomu.new file

      assert_includes yomu.text, 'The quick brown fox jumped over the lazy cat.'
    end
  end

  def test_yomu_initialized_with_a_stream_can_read_metadata
    File.open 'test/samples/sample.pages', 'rb' do |file|
      yomu = Yomu.new file

      assert_equal 'application/vnd.apple.pages', yomu.metadata['Content-Type']
    end
  end
end