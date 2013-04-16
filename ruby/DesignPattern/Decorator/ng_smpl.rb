class EnhancedWriter
  attr_reader :check_sum

  def initialize(path)
    @file = File.open(path, "w")
    @check_sum = 0
    @line_number = 1
  end

  def write_line(line)
    @file.print(line)
    @file.print("\n")
  end

  def checksumming_write_line(data)
    data.each_byte{|byte| @check_sum = (@check_sum + byte) % 256}
  end

  def timestamping_writer_line(data)
    write_line("#{Time.now}: #{data}")
  end

  def numberig_write_line(data)
    write_line("%{@line_number}: #{data}")
    @line_number += 1
  end

  def close
    @file.close
  end
end

writer = EnhancedWriter.new('out.txt')

#writer.write_line("hogehoge")

#writer.checksumming_write_line("fugafuga")
#puts("checksum: #{writer.check_sum}")

writer.timestamping_writer_line("piyopiyo")
