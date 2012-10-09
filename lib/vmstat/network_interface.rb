module Vmstat
  class NetworkInterface < Struct.new(:name, :in_bytes, :in_errors, :in_drops,
                                      :out_bytes, :out_errors, :type)

    # The type of ethernet devices on freebsd/mac os x
    ETHERNET_TYPE = 0x06

    # The type of loopback devices on freebsd/mac os x
    LOOPBACK_TYPE = 0x18

    def loopback?
      type == LOOPBACK_TYPE
    end

    def ethernet?
      type == ETHERNET_TYPE
    end
  end
end
