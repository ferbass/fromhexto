require 'minitest/autorun'
require_relative 'fromhexto'

class FromHexToTest < Minitest::Test
  def test_hex_to_ascii_big_endian
    result = FromHexTo.fromhexto(input: "48656c6c6f", input_format: :hex, endianess: :big, output_format: :ascii)
    assert_equal "Hello", result
  end

  def test_string_to_hex
    result = FromHexTo.fromhexto(input: "Hello", input_format: :str, endianess: :big, output_format: :hex)
    assert_equal "48656c6c6f", result
  end

  def test_decimal_to_hex_little_endian
    result = FromHexTo.fromhexto(input: "111 108 108 101 72", input_format: :dec, endianess: :little, output_format: :hex)
    assert_equal "48656c6c6f", result
  end

  def test_hex_to_decimal_big_endian
    result = FromHexTo.fromhexto(input: "48656c6c6f", input_format: :hex, endianess: :big, output_format: :decimal)
    assert_equal "72 101 108 108 111", result
  end

  def test_string_to_decimal
    result = FromHexTo.fromhexto(input: "Hello", input_format: :str, endianess: :big, output_format: :decimal)
    assert_equal "72 101 108 108 111", result
  end

  def test_little_endian_effect
    big_endian = FromHexTo.fromhexto(input: "48656c6c6f", input_format: :hex, endianess: :big, output_format: :hex)
    little_endian = FromHexTo.fromhexto(input: "48656c6c6f", input_format: :hex, endianess: :little, output_format: :hex)
    refute_equal big_endian, little_endian
    assert_equal big_endian, little_endian.scan(/../).reverse.join
  end
end

