# Vmstat

This is a focused and fast library to get system information like:

* _Memory_ (free, active, ...)
* _Network Devices_ (name, in bytes, out bytes, ...)
* _CPU_ (user, system, nice, idle)
* _Load_ Average
* _Disk_ (type, disk path, free bytes, total bytes, ...)

*It currently supports:*

* FreeBSD
* MacOS X

*It might support (but not tested):*

* OpenBSD
* NetBSD

## Installation

Add this line to your application's Gemfile:

    gem 'vmstat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vmstat

## Usage

Just require the library.

	require "vmstat"

### Memory

	Vmstat.memory # => {...}

The result might look like this:

	{:pagesize=>4096,
	 :wired=>668069,
	 :active=>185474,
	 :inactive=>546881,
	 :free=>694851,
	 :wired_bytes=>2240024576,
	 :active_bytes=>2736410624,
	 :inactive_bytes=>759701504,
	 :free_bytes=>2846109696,
	 :zero_filled=>176898850,
	 :reactivated=>41013,
	 :purgeable=>344211,
	 :purged=>11580,
	 :pageins=>2254222,
	 :pageouts=>0,
	 :faults=>204524839,
	 :copy_on_write_faults=>14379007,
	 :lookups=>2255061,
	 :hits=>95}


### Network Devices

	Vmstat.network # => {...}

The result might look like this:

	{:lo0=>
	  {:in_bytes=>9082607,
	   :in_errors=>0,
	   :in_drops=>0,
	   :out_bytes=>9082607,
	   :out_errors=>0,
	   :type=>24},
	 :gif0=>
	  {:in_bytes=>0,
	   :in_errors=>0,
	   :in_drops=>0,
	   :out_bytes=>0,
	   :out_errors=>0,
	   :type=>55},
	 :stf0=>
	  {:in_bytes=>0,
	   :in_errors=>0,
	   :in_drops=>0,
	   :out_bytes=>0,
	   :out_errors=>0,
	   :type=>57},
	 :en0=>
	  {:in_bytes=>7108891975,
	   :in_errors=>0,
	   :in_drops=>0,
	   :out_bytes=>479503412,
	   :out_errors=>0,
	   :type=>6},
	 :p2p0=>
	  {:in_bytes=>0,
	   :in_errors=>0,
	   :in_drops=>0,
	   :out_bytes=>0,
	   :out_errors=>0,
	   :type=>6}}

### CPU
	
	Vmstat.cpu # => [...]

The result might look like this, depending on the number of cpus:

	[{:user=>297003, :system=>475804, :nice=>0, :idle=>11059640},
	 {:user=>23349,  :system=>14186,  :nice=>0, :idle=>11792093},
	 {:user=>247171, :system=>195309, :nice=>0, :idle=>11387262},
	 {:user=>21783,  :system=>12823,  :nice=>0, :idle=>11794993},
	 {:user=>221323, :system=>163723, :nice=>0, :idle=>11444653},
	 {:user=>20608,  :system=>11808,  :nice=>0, :idle=>11797154},
	 {:user=>195015, :system=>145772, :nice=>0, :idle=>11488869},
	 {:user=>19793,  :system=>11077,  :nice=>0, :idle=>11798671}]

### Load

	Vmstat.load_avg #=> [0.35791015625, 0.4296875, 0.4609375]

### Disk

To get the disk data one can pass the mount point or the device name.

	# like so
	Vmstat.disk("/") # => {...}

	# or so
	Vmstat.disk("/dev/disk0s2") # => {...}

The result looks like this:

	{:type				=>	:devfs,
	 :origin			=>	"devfs",
	 :mount				=>	"/dev",
	 :free_bytes		=>	0,
	 :available_bytes	=>	0,
	 :used_bytes		=>	192000,
	 :total_bytes		=>	192000}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
