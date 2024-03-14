require 'optparse'

module FromHexTo
  def self.fromhexto(input:, input_format:, endianess:, output_format:)
    binary_data = case input_format
                  when :hex
                    [input.gsub(/0x|[\s,]/, '')].pack('H*')
                  when :str
                    input
                  when :dec
                    input.split.map { |num| num.to_i.chr(Encoding::BINARY) }.join
                  else
                    raise ArgumentError, "Invalid input format"
                  end

    binary_data.reverse! if endianess == :little

    case output_format
    when :hex
      binary_data.unpack1('H*')
    when :ascii, :utf8
      binary_data.force_encoding('UTF-8')
    when :decimal
      binary_data.bytes.map(&:to_s).join(' ')
    else
      raise ArgumentError, "Invalid output format"
    end
  end

  def self.parse_cli_args_and_convert(argv)
    options = { endianess: :big, input_format: :hex, output_format: :hex }
    parser = OptionParser.new do |opts|
      opts.on("-iINPUT", "--input INPUT", "Input to convert") { |v| options[:input] = v }
      opts.on("-fFORMAT", "--input-format FORMAT", [:hex, :str, :dec], "Input format (hex, str, dec)") { |v| options[:input_format] = v }
      opts.on("-eENDIANESS", "--endianess ENDIANESS", [:big, :little], "Endianess (big or little)") { |v| options[:endianess] = v }
      opts.on("-oFORMAT", "--output FORMAT", [:hex, :ascii, :utf8, :decimal], "Output format (hex, ascii, utf-8, decimal)") { |v| options[:output_format] = v }
      opts.on("-h", "--help", "Prints this help") do
        puts opts
        exit
      end

    end

    begin
      parser.parse!(argv)
      raise OptionParser::MissingArgument if argv.empty? && options[:input].nil?
    rescue OptionParser::MissingArgument, OptionParser::InvalidOption
      puts parser
      exit
    end

    puts fromhexto(**options)
  end
end

# CLI usage
FromHexTo.parse_cli_args_and_convert(ARGV) if __FILE__ == $PROGRAM_NAME
