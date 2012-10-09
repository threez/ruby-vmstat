require "vmstat/version"

module Vmstat
  autoload :Cpu,              "vmstat/cpu"
  autoload :NetworkInterface, "vmstat/network_interface"
  autoload :Disk,             "vmstat/disk"
  autoload :Memory,           "vmstat/memory"
  autoload :Task,             "vmstat/task"
  autoload :LoadAverage,      "vmstat/load_average"
  autoload :Snapshot,         "vmstat/snapshot"

  # Creates a full snapshot of the systems hardware statistics.
  # @param [Array<String>] the paths to the disks to snapshot.
  # @return [Vmstat::Snapshot] a snapshot of all statistics.
  # @example
  #   Vmstat.snapshot # => #<struct Vmstat::Snapshot ...>
  def self.snapshot(paths = ["/"])
    Snapshot.new(paths)
  end

  # Fetches the boot time of the system.
  # @return [Time] the boot time as regular time object.
  # @example
  #   Vmstat.boot_time # => 2012-10-09 18:42:37 +0200
  def self.boot_time
    # implemented in native extension ...
  end

  # Fetches the cpu statistics (usage counter for user, nice, system and idle)
  # @return [Array<Vmstat::Cpu>] the array of cpu counter
  # @example
  #   Vmstat.cpu # => [#<struct Vmstat::Cpu ...>, #<struct Vmstat::Cpu ...>]
  def self.cpu
    # implemented in native extension ...
  end

  # Fetches the usage data and other useful disk information for the given path.
  # @param [String] path the path (mount point or device path) to the disk
  # @return [Vmstat::Disk] the disk information
  # @example
  #   Vmstat.disk("/") # => #<struct Vmstat::Disk type=:hfs, ...>
  def self.disk(path)
    # implemented in native extension ...
  end

  # Fetches the load average for the current system.
  # @return [Vmstat::LoadAverage] the load average data
  # @example
  #   Vmstat.load_average # => #<struct Vmstat::LoadAverage one_minute=...>
  def self.load_average
    # implemented in native extension ...
  end

  # Fetches the memory usage information.
  # @return [Vmstat::Memory] the memory data like free, used und total.
  # @example
  #   Vmstat.memory # => #<struct Vmstat::Memory ...>
  def self.memory
    # implemented in native extension ...
  end

  # Fetches the information for all available network devices.
  # @return [Array<Vmstat::NetworkInterface>] the network device information
  # @example
  #   Vmstat.network_interfaces # => [#<struct Vmstat::NetworkInterface ...>, ...]
  def self.network_interfaces
    # implemented in native extension ...
  end

  # Fetches time and memory usage for the current process.
  # @note Currently only on Mac OS X
  # @return [Array<Vmstat::Task>] the network device information
  # @example
  #   Vmstat.task # => #<struct Vmstat::Task ...>
  def self.task
    # implemented in native extension ...
  end

  # Filters all available ethernet devices.
  # @return [Array<NetworkInterface>] the ethernet devices
  def self.ethernet_devices
    network_interfaces.select(&:ethernet?)
  end

  # Filters all available loopback devices.
  # @return [Array<NetworkInterface>] the loopback devices
  def self.loopback_devices
    network_interfaces.select(&:loopback?)
  end
end

require "vmstat/vmstat" # native lib
