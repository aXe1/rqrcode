module RQRCode

  class QRNumeric
    attr_reader :mode

    def initialize( data )
      @mode = QRMODE[:mode_number]

      raise QRCodeArgumentError, "Not a numeric string `#{data}`" unless QRNumeric.valid_data?(data)

      @data = data;
    end


    def get_length
      @data.size
    end

    def self.valid_data? data
      (data =~ /\A\d+\z/) ? true : false
    end


    def write(buffer)
      buffer.numeric_encoding_start(get_length)
      
      (@data.size / 3).times do |i|
        buffer.put(@data[i*3..i*3+2].to_i, 10)
      end
      
      reminder_size = @data.size % 3
      if reminder_size != 0
        reminder = @data[-(reminder_size)..-1].to_i
        reminder_size_in_bits = reminder_size == 1 ? 4 : 7
        buffer.put(reminder, reminder_size_in_bits)
      end
    end
  end
end
