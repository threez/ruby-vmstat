module Vmstat
  class Task < Struct.new(:suspend_count, :virtual_size, :resident_size,
                          :user_time_ms, :system_time_ms)
  end
end
 