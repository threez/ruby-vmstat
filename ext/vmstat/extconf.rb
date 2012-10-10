require 'mkmf'

# mach.c
have_header 'mach/mach.h'

# statfs.c
have_header 'sys/param.h'
have_header 'sys/mount.h'
have_func 'statfs'

# sysctl.c
headers = ['unistd.h', 'sys/sysctl.h', 'sys/types.h', 'sys/socket.h',
           'net/if.h', 'net/if_mib.h', 'net/if_types.h']
headers.each { |header| have_header header }
have_func 'getloadavg'
have_func 'sysctl'
have_type 'struct ifmibdata', headers
have_const 'CTL_NET', headers
have_const 'PF_LINK', headers
have_const 'NETLINK_GENERIC', headers
have_const 'IFMIB_IFDATA', headers
have_const 'IFDATA_GENERAL', headers
have_const 'CTL_KERN', headers
have_const 'KERN_BOOTTIME', headers

create_header

create_makefile 'vmstat/vmstat'