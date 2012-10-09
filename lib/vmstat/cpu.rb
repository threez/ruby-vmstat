module Vmstat
  class Cpu < Struct.new(:num, :user, :system, :nice, :idle)
  end
end
