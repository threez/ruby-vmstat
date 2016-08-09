module Vmstat
  def self.cpu
    kstat = `kstat -p "cpu_stat:::/idle|kernel|user/"`
    cpus = Hash.new { |h, k| h[k] = Hash.new }

    kstat.lines.each do |line|
      _, _, cpu, key, value = line.strip.split(/:|\s+/)
      values[cpu] = value
    end

    cpus.map do |k, v|
      name = k.gsub(/cpu_stat/, "").to_i
      Cpu.new(name, v["user"].to_i, v["kernel"].to_i, 0, v["idle"].to_i)
    end
  end

  def self.boot_time
    Time.at(`kstat -p unix:::boot_time`.strip.split(/\s+/).last.to_i)
  end

  def self.memory
    kstat = `kstat -p -n system_pages`
    values = Hash.new

    kstat.lines.each do |line|
      _, _, _, key, value = line.strip.split(/:|\s+/)
      values[key] = value
    end

    total = values['pagestotal'].to_i
    free = values['pagesfree'].to_i
    locked = values['pageslocked'].to_i

    Memory.new(pagesize,
               locked, # wired
               total - free - locked, # active
               0, # inactive
               free, # free
               0, #pageins
               0) #pageouts
  end

  def self.network_interfaces
    kstat = `kstat -p link:::`
    itfs = Hash.new { |h, k| h[k] = Hash.new }

    kstat.lines.each do |line|
      _, _, name, key, value = line.strip.split(/:|\s+/)
      itfs[name][key] = value
    end

    itfs.map do |k, v|
      NetworkInterface.new(k, v['rbytes64'].to_i,
                              v['ierrors'].to_i,
                              0,
                              v['obytes64'].to_i,
                              v['oerrors'].to_i,
                              NetworkInterface::ETHERNET_TYPE)
    end
  end
end
