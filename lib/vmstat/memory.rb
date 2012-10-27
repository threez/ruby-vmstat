module Vmstat
  # Gathered memory data snapshot.
  # @attr [Fixnum] pagesize
  #   The page size of the memory in bytes.
  # @attr [Fixnum] wired
  #   The number of wired pages in the system.
  # @attr [Fixnum] active
  #   The number of active pages in the system.
  # @attr [Fixnum] inactive
  #   The number of inactive pages in the system.
  # @attr [Fixnum] free
  #   The number of free pages in the system.
  # @attr [Fixnum] pageins
  #   The number of pageins.
  # @attr [Fixnum] pageouts
  #   The number of pageouts.
  class Memory < Struct.new(:pagesize, :wired, :active, :inactive, :free,
                            :pageins, :pageouts)
    # Calculate the wired bytes based of the wired pages.
    # @return [Fixnum] wired bytes
    def wired_bytes
      wired *  pagesize
    end

    # Calculate the active bytes based of the active pages.
    # @return [Fixnum] active bytes
    def active_bytes
      active * pagesize
    end

    # Calculate the inactive bytes based of the inactive pages.
    # @return [Fixnum] inactive bytes
    def inactive_bytes
      inactive * pagesize
    end

    # Calculate the free bytes based of the free pages.
    # @return [Fixnum] free bytes
    def free_bytes
      free * pagesize
    end
  end
end
