require "vmstat/version"
require "vmstat/vmstat" # native lib

module Vmstat
  # The type of ethernet devices on freebsd/mac os x
  ETHERNET_TYPE = 0x06

  # The type of loopback devices on freebsd/mac os x
  LOOPBACK_TYPE = 0x18

  # Filters all available ethernet devices.
  # @return [Hash<Symbol, Hash>] the ethernet device name and values
  # @example
  #   Vmstat.ethernet_devices # => { :en0 => {
  #   #    :in_bytes=>7104874723,
  #   #    :in_errors=>0,
  #   #    :in_drops=>0,
  #   #    :out_bytes=>478849502,
  #   #    :out_errors=>0,
  #   #    :type=>6},
  #   #  :p2p0=> ...
  def self.ethernet_devices
    filter_devices ETHERNET_TYPE
  end

  # Filters all available loopback devices.
  # @return [Hash<Symbol, Hash>] the loopback device name and values
  # @example
  #   Vmstat.loopback_devices # => { :lo0 => { 
  #   # :in_bytes=>6935997,
  #   # :in_errors=>0,
  #   # :in_drops=>0,
  #   # :out_bytes=>6935997,
  #   # :out_errors=>0,
  #   # :type=>24
  #   # }}
  def self.loopback_devices
    filter_devices LOOPBACK_TYPE
  end

  # A method to filter the devices.
  # @param [Fixnum] type the type to filter for
  # @return [Hash<Symbol, Hash>] the filtered device name and values
  # @api private
  def self.filter_devices(type)
    network.select do |name, attrbutes|
      attrbutes[:type] == type
    end
  end
end
