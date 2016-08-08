require "time"

module Vmstat
  def self.cpu
    mpstat = `mpstat 1 1`.lines
    mpstat.shift # ignore header
    mpstat.map do |line|
      num, *rest, user, sys, _, idle = line.strip.split(/\s+/)
      Cpu.new(num.to_i, user.to_i, sys.to_i, 0, idle.to_i]
    end
  end
  
  def self.boot_time
    Time.parse(`who -b`.gsub(/^.*boot\s+/, "").gsub(/\s+/, " ").strip)
  end

  def self.load_average
    uptime = `uptime`.gsub(",", ".")
    LoadAverage.new(*uptime.gsub(/\d+(\.\d+)?/).to_a[-3..-1].map(&:to_f))
  end

  def self.memory
    memstat = `echo ::memstat | mdb -k`
    vmstat = `vmstat -s`

    Memory.new(
      `pagesize`.to_i, # pagesize
      # wired
      extract_solaris_mval(memstat, 'Kernel', 'Boot pages', 'ZFS File Data'),
      # active
      extract_solaris_mval(memstat, 'Exec and libs'),
      # inactive
      extract_solaris_mval(memstat, 'Page cache', 'Anon'),
      # free
      extract_solaris_mval(memstat, 'Free \(cachelist\)', 'Free \(freelist\)'), 
      extract_solaris_val(vmstat, 'page ins'), # pageins
      extract_solaris_val(vmstat, 'page outs') # pageouts
    )
  end

  def self.network_interfaces
    dlstat = `dlstat -u R` 
    dlstat.shift # ignore header
    dlstat.map do |line|
      # LINK    IPKTS   RBYTES    OPKTS   OBYTES
      link, ipkts, rbytes, opkts, obytes = line.strip.split(/\s+/)
      NetworkInterface.new(link, rbytes, 0, 0, obytes, 0, 
        NetworkInterface::ETHERNET_TYPE)
    end    
  end

  def self.extract_solaris_val(uvmexp, name)
    regexp = Regexp.new('(\d+)\s' + name)
    uvmexp.lines.grep(regexp) do |line|
      return $1.to_i
    end
  end
  
  def self.extract_solaris_mval(memstat, *names)
    val = 0 
    names.each do |name|
      regexp = Regexp.new(name + '\s+(\d+)')
      memstat.grep(regexp) do |line|
        val += $1.to_i
      end
    end
    val
  end
end
