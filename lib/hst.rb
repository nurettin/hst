require "hst/version"

module Hst
  def self.Format(version)
    case version
    when 400 then [44, 'ID5']
    when 401 then [60, 'QD4QIQ']
    else raise "Unsupported version #{version}. [400, 401] required."
    end
  end

  class Reader
    attr_reader :version
    attr_reader :copyright
    attr_reader :symbol
    attr_reader :period
    attr_reader :digits
    attr_reader :timesign
    attr_reader :lastsync
    
    def initialize(file)
      open(file)
    end

    def open(file)
      @f = File.open(file, 'rb')
      e = @f.read(96).unpack('IC64C12I4')
      raise "File size too small (must be >= 96 bytes)" if e[-1].nil?
      @version = e[0]
      @packet_size, @packet_format = Hst::Format(@version)
      @copyright = e[1..64].pack('C64')
      @symbol = e[65..76].pack('C12')
      @period = e[77]
      @digits = e[78]
      @timesign = Time.at(e[79])
      @lastsync = Time.at(e[80])
      @f.read(52)
    end

    def read
      while not @f.eof do
        data = @f.read(@packet_size)
        t, o, h, l, c, v, s, rv = data.unpack(@packet_format)
        yield Time.at(t), o, h, l, c, v, s, rv
      end
      @f.close
    end
  end

  class Writer
    def initialize(file, version, symbol, period = 1, digits = 5, timesign = Time.now, lastsync = Time.now, &block)
      create(file, version, symbol, period, digits, timesign, lastsync, &block)
    end

    def create(file, version, symbol, period, digits, timesign, lastsync, &block)
      @f = File.open(file, 'wb')
      @packet_size, @packet_format = Hst::Format(version)
      header = [version, 40, 67, 41, 111, 112, 121, 114, 105, 103, 104, 116, 32, 50, 48, 48, 51, 44, 32, 77, 101, 116, 97, 81, 117, 111, 116, 101, 115, 32, 83, 111, 102, 116, 119, 97, 114, 101, 32, 67, 111, 114, 112, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      header += symbol.unpack('C*').fill 0, symbol.length, 12 - symbol.length
      header += [period, digits, timesign.to_i, lastsync.to_i] + [0] * 52
      @f.write header.pack('IC64C12I4C52')
      yield self
      @f.close
    end

    def write(t, o, h, l, c, v, s = nil, rv = nil)
      @f.write [t.to_i, o, h, l, c, v, s, rv].pack(@packet_format)
    end
  end
end

