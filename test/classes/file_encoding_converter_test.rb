require 'test_helper'

class FileEncodingConverterTest < ActiveSupport::TestCase
  setup do
    temp = Tempfile.new 'utf', nil, encoding: 'UTF-8'
    temp.write 'åäö € ❤ UTF-8'
    temp.close

    @utffile = temp.path

    temp = Tempfile.new 'iso15', nil, encoding: 'ISO-8859-15'
    temp.write 'åäö € ISO-15'
    temp.close

    @isofile = temp.path
  end

  teardown do
    File.delete @utffile
    File.delete @isofile
  end

  test 'initialize' do
    assert_raises(ArgumentError) { FileEncodingConverter.new }
    assert_raises(ArgumentError) { FileEncodingConverter.new filename: 'foo.txt', encoding: 'foo' }

    assert FileEncodingConverter.new filename: 'foo.txt', encoding: 'UTF-8'
    assert FileEncodingConverter.new filename: 'foo.txt', encoding: 'ISO-8859-15'
  end

  test 'convert utf8 to utf8' do
    assert FileEncodingConverter.new(filename: @utffile, encoding: 'UTF-8').convert
    content = File.read @utffile, encoding: 'UTF-8'

    assert_equal 'åäö € ❤ UTF-8', content
  end

  test 'convert utf8 to iso15' do
    assert FileEncodingConverter.new(filename: @utffile, encoding: 'ISO-8859-15').convert
    content = File.read @utffile, encoding: 'ISO-8859-15'

    assert_equal 'åäö € ? UTF-8', content
  end

  test 'convert utf8 to iso1' do
    assert FileEncodingConverter.new(filename: @utffile, encoding: 'ISO-8859-1').convert
    content = File.read @utffile, encoding: 'ISO-8859-1'

    assert_equal 'åäö ? ? UTF-8', content
  end

  test 'convert iso15 to utf' do
    assert FileEncodingConverter.new(filename: @isofile, encoding: 'UTF-8').convert
    content = File.read @isofile, encoding: 'ISO-8859-15'

    assert_equal 'åäö € ISO-15', content
  end
end
