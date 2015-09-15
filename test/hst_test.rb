require 'test_helper'

class HstTest < Minitest::Test
  def test_read_write
    output1 = [Time.at(1441103160), 1.13033, 1.13043, 1.12986, 1.12995, 73, 0, 0]
    output2 = [Time.at(1441103220), 1.12994, 1.13017, 1.12982, 1.13015, 59, 0, 0]

    Hst::Writer.new 'test.hst', 401, 'EURUSD', 1, 5, Time.now, Time.now do |hst|
      hst.write *output1
      hst.write *output2
    end

    inputs = []
    hst = Hst::Reader.new 'test.hst'
    hst.read do |t, o, h, l, c, v, s, rv|
      inputs << [t, o, h, l, c, v, s, rv]
    end

    assert [output1, output2] == inputs
    File.delete('test.hst')
  end
end
