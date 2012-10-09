module Vmstat
  class LoadAverage < Struct.new(:one_minute, :five_minutes, :fifteen_minutes)
  end
end
