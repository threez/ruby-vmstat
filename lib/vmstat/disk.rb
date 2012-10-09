module Vmstat
  class Disk < Struct.new(:type, :origin, :mount, :block_size, 
                          :free_blocks, :available_blocks, :total_blocks)
    def free_bytes
      free_blocks * block_size
    end

    def available_bytes
      available_blocks * block_size
    end

    def used_bytes
      (total_blocks - free_blocks) * block_size
    end

    def total_bytes
      total_blocks * block_size
    end
  end
end
