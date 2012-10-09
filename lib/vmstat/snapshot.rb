module Vmstat
  class Snapshot
    attr_reader :at, :boot_time, :cpu, :disks, :load_average,
                :memory, :network_interfaces, :task

    def initialize(paths = [])
      @at = Time.now
      @boot_time = Vmstat.boot_time
      @cpu = Vmstat.cpu
      @disks = paths.map { |path| Vmstat.disk(path) }
      @load_average = Vmstat.load_average
      @memory = Vmstat.memory
      @network_interfaces = Vmstat.network_interfaces
      @task = Vmstat.task
    end
  end
end
