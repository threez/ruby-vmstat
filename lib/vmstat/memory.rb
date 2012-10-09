module Vmstat
  class Memory < Struct.new(:pagesize,
                            :wired, :active, :inactive, :free,
                            :pageins, :pageouts,
                            :zero_filled, :reactivated, :purgeable,
                            :purged, :faults,
                            :copy_on_write_faults, :lookups, :hits)
    def wired_bytes
      wired *  pagesize
    end

    def active_bytes
      active * pagesize
    end

    def inactive_bytes
      inactive * pagesize
    end

    def free_bytes
      free * pagesize
    end
  end
end
