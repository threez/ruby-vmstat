#include <sys/types.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_mib.h>
#include <net/if_types.h>
#include <sys/param.h>
#include <sys/mount.h>
#if defined(__APPLE__)
#include <mach/mach.h>
#endif
#include <vmstat.h>

void Init_vmstat() {
  vmstat = rb_define_module("Vmstat");

  rb_define_singleton_method(vmstat, "network", method_network, 0);
  rb_define_singleton_method(vmstat, "cpu", method_cpu, 0);
  rb_define_singleton_method(vmstat, "memory", method_memory, 0);
  rb_define_singleton_method(vmstat, "disk", method_disk, 1);
  rb_define_singleton_method(vmstat, "load_avg", method_load_avg, 0);
  rb_define_singleton_method(vmstat, "boot_time", method_boot_time, 0);

  // widely used symbols
  SYM_TYPE = ID2SYM(rb_intern("type"));
  SYM_FREE = ID2SYM(rb_intern("free"));

  // network symbols
  SYM_IN_BYTES = ID2SYM(rb_intern("in_bytes"));
  SYM_IN_ERRORS = ID2SYM(rb_intern("in_errors"));
  SYM_IN_DROPS = ID2SYM(rb_intern("in_drops"));
  SYM_OUT_BYTES = ID2SYM(rb_intern("out_bytes"));
  SYM_OUT_ERRORS = ID2SYM(rb_intern("out_errors"));

  // cpu symbols
  SYM_USER = ID2SYM(rb_intern("user"));
  SYM_SYSTEM = ID2SYM(rb_intern("system"));
  SYM_NICE = ID2SYM(rb_intern("nice"));
  SYM_IDLE = ID2SYM(rb_intern("idle"));

  // memory symbols
  SYM_PAGESIZE = ID2SYM(rb_intern("pagesize"));
  SYM_WIRED = ID2SYM(rb_intern("wired"));
  SYM_ACTIVE = ID2SYM(rb_intern("active"));
  SYM_INACTIVE = ID2SYM(rb_intern("inactive"));
  SYM_WIRED_BYTES = ID2SYM(rb_intern("wired_bytes"));
  SYM_ACTIVE_BYTES = ID2SYM(rb_intern("active_bytes"));
  SYM_INACTIVE_BYTES = ID2SYM(rb_intern("inactive_bytes"));
  SYM_FREE_BYTES = ID2SYM(rb_intern("free_bytes"));
  SYM_ZERO_FILLED = ID2SYM(rb_intern("zero_filled"));
  SYM_REACTIVATED = ID2SYM(rb_intern("reactivated"));
  SYM_PURGEABLE = ID2SYM(rb_intern("purgeable"));
  SYM_PURGED = ID2SYM(rb_intern("purged"));
  SYM_PAGEINS = ID2SYM(rb_intern("pageins"));
  SYM_PAGEOUTS = ID2SYM(rb_intern("pageouts"));
  SYM_FAULTS = ID2SYM(rb_intern("faults"));
  SYM_COW_FAULTS = ID2SYM(rb_intern("copy_on_write_faults"));
  SYM_LOOKUPS = ID2SYM(rb_intern("lookups"));
  SYM_HITS = ID2SYM(rb_intern("hits"));

  // disk symbols
  SYM_ORIGIN = ID2SYM(rb_intern("origin"));
  SYM_MOUNT = ID2SYM(rb_intern("mount"));
  SYM_AVAILABLE_BYTES = ID2SYM(rb_intern("available_bytes"));
  SYM_USED_BYTES = ID2SYM(rb_intern("used_bytes"));
  SYM_TOTAL_BYTES = ID2SYM(rb_intern("total_bytes"));
}

VALUE method_network(VALUE self) {
  VALUE devices = rb_hash_new();
  int i, err;
  struct ifmibdata mibdata;
  size_t len = sizeof(mibdata);
  int ifmib_path[] = {
    CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_IFDATA, -1, IFDATA_GENERAL
  };

  for (i = 1, err = 0; err == 0; i++) {
    ifmib_path[4] = i; // set the current row
    err = sysctl(ifmib_path, 6, &mibdata, &len, NULL, 0);
    if (err == 0) {
      VALUE device = rb_hash_new();
      rb_hash_aset(device, SYM_IN_BYTES, ULL2NUM(mibdata.ifmd_data.ifi_ibytes));
      rb_hash_aset(device, SYM_IN_ERRORS, ULL2NUM(mibdata.ifmd_data.ifi_ierrors));
      rb_hash_aset(device, SYM_IN_DROPS, ULL2NUM(mibdata.ifmd_data.ifi_iqdrops));
      rb_hash_aset(device, SYM_OUT_BYTES, ULL2NUM(mibdata.ifmd_data.ifi_obytes));
      rb_hash_aset(device, SYM_OUT_ERRORS, ULL2NUM(mibdata.ifmd_data.ifi_oerrors));
      rb_hash_aset(device, SYM_TYPE, ULL2NUM(mibdata.ifmd_data.ifi_type));
      rb_hash_aset(devices, ID2SYM(rb_intern(mibdata.ifmd_name)), device);
    }
  }

  return devices;
}

#if defined(__APPLE__)
VALUE method_cpu(VALUE self) {
  VALUE cpus = rb_ary_new();
  processor_info_array_t cpuInfo;
  mach_msg_type_number_t numCpuInfo;
  natural_t numCPUsU = 0U;
  kern_return_t err = host_processor_info(mach_host_self(),
    PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);

  if(err == KERN_SUCCESS) {
    unsigned i;
    for(i = 0U; i < numCPUsU; ++i) {
      VALUE cpu = rb_hash_new();
      int pos = CPU_STATE_MAX * i;
      rb_hash_aset(cpu, SYM_USER, ULL2NUM(cpuInfo[pos + CPU_STATE_USER]));
      rb_hash_aset(cpu, SYM_SYSTEM, ULL2NUM(cpuInfo[pos + CPU_STATE_SYSTEM]));
      rb_hash_aset(cpu, SYM_NICE, ULL2NUM(cpuInfo[pos + CPU_STATE_NICE]));
      rb_hash_aset(cpu, SYM_IDLE, ULL2NUM(cpuInfo[pos + CPU_STATE_IDLE]));
      rb_ary_push(cpus, cpu);
    }
  }
  
  return cpus;
}

VALUE method_memory(VALUE self) {
  VALUE memory = Qnil;
  vm_size_t pagesize;
  uint host_count = HOST_VM_INFO_COUNT;
  kern_return_t err;
  vm_statistics_data_t vm_stat;
  
  err = host_page_size(mach_host_self(), &pagesize);
  if (err == KERN_SUCCESS) {
    err = host_statistics(mach_host_self(), HOST_VM_INFO,
                          (host_info_t)&vm_stat, &host_count);
    if (err == KERN_SUCCESS) {
      memory = rb_hash_new();
      rb_hash_aset(memory, SYM_PAGESIZE, ULL2NUM(pagesize));
      rb_hash_aset(memory, SYM_WIRED, ULL2NUM(vm_stat.active_count));
      rb_hash_aset(memory, SYM_ACTIVE, ULL2NUM(vm_stat.inactive_count));
      rb_hash_aset(memory, SYM_INACTIVE, ULL2NUM(vm_stat.wire_count));
      rb_hash_aset(memory, SYM_FREE, ULL2NUM(vm_stat.free_count));
      rb_hash_aset(memory, SYM_WIRED_BYTES, ULL2NUM(vm_stat.wire_count * pagesize));
      rb_hash_aset(memory, SYM_ACTIVE_BYTES, ULL2NUM(vm_stat.active_count * pagesize));
      rb_hash_aset(memory, SYM_INACTIVE_BYTES, ULL2NUM(vm_stat.inactive_count * pagesize));
      rb_hash_aset(memory, SYM_FREE_BYTES, ULL2NUM(vm_stat.free_count * pagesize));
      rb_hash_aset(memory, SYM_ZERO_FILLED, ULL2NUM(vm_stat.zero_fill_count));
      rb_hash_aset(memory, SYM_REACTIVATED, ULL2NUM(vm_stat.reactivations));
      rb_hash_aset(memory, SYM_PURGEABLE, ULL2NUM(vm_stat.purgeable_count));
      rb_hash_aset(memory, SYM_PURGED, ULL2NUM(vm_stat.purges));
      rb_hash_aset(memory, SYM_PAGEINS, ULL2NUM(vm_stat.pageins));
      rb_hash_aset(memory, SYM_PAGEOUTS, ULL2NUM(vm_stat.pageouts));
      rb_hash_aset(memory, SYM_FAULTS, ULL2NUM(vm_stat.faults));
      rb_hash_aset(memory, SYM_COW_FAULTS, ULL2NUM(vm_stat.cow_faults));
      rb_hash_aset(memory, SYM_LOOKUPS, ULL2NUM(vm_stat.lookups));
      rb_hash_aset(memory, SYM_HITS, ULL2NUM(vm_stat.hits));
    }
  }
  
  return memory;
}
#elif __linux
    // linux
#elif __unix // all unices not caught above
typedef struct {
  long user;
  long nice;
  long system;
  long intr;
  long idle;
} cpu_time_t;

VALUE method_cpu(VALUE self) {
  VALUE cpus = rb_ary_new();
  int cpu_count = system_int("hw.ncpu");
  size_t len = sizeof(cpu_time_t) * cpu_count;
  cpu_time_t * cp_times = ALLOC_N(cpu_time_t, cpu_count);
  int i;
  
  if (sysctlbyname("kern.cp_times", cp_times, &len, NULL, 0) == 0) {
    for (i = 0; i < cpu_count; i++) {
      VALUE cpu = rb_hash_new();
      cpu_time_t cp_time = cp_times[i];
      rb_hash_aset(cpu, SYM_USER, LONG2NUM(cp_time.user));
      rb_hash_aset(cpu, SYM_SYSTEM, LONG2NUM(cp_time.system + cp_time.intr));
      rb_hash_aset(cpu, SYM_NICE, LONG2NUM(cp_time.nice));
      rb_hash_aset(cpu, SYM_IDLE, LONG2NUM(cp_time.idle));
      rb_ary_push(cpus, cpu);
    }
  }
  free(cp_times);
  
  return cpus;
}

VALUE method_memory(VALUE self) {
  VALUE memory = rb_hash_new();
  unsigned long long pagesize = system_ull("vm.stats.vm.v_page_size");

  rb_hash_aset(memory, SYM_PAGESIZE, ULL2NUM(pagesize));
  rb_hash_aset(memory, SYM_WIRED, ULL2NUM(system_ull("vm.stats.vm.v_inactive_count")));
  rb_hash_aset(memory, SYM_ACTIVE, ULL2NUM(system_ull("vm.stats.vm.v_active_count")));
  rb_hash_aset(memory, SYM_INACTIVE, ULL2NUM(system_ull("vm.stats.vm.v_wire_count")));
  rb_hash_aset(memory, SYM_FREE, ULL2NUM(system_ull("vm.stats.vm.v_free_count")));
  rb_hash_aset(memory, SYM_WIRED_BYTES, ULL2NUM((system_ull("vm.stats.vm.v_cache_count") +
                                                 system_ull("vm.stats.vm.v_wire_count")) * pagesize));
  rb_hash_aset(memory, SYM_ACTIVE_BYTES, ULL2NUM(system_ull("vm.stats.vm.v_active_count") * pagesize));
  rb_hash_aset(memory, SYM_INACTIVE_BYTES, ULL2NUM(system_ull("vm.stats.vm.v_inactive_count") * pagesize));
  rb_hash_aset(memory, SYM_FREE_BYTES, ULL2NUM(system_ull("vm.stats.vm.v_free_count") * pagesize));
  rb_hash_aset(memory, SYM_ZERO_FILLED, ULL2NUM(system_ull("vm.stats.misc.zero_page_count")));
  rb_hash_aset(memory, SYM_REACTIVATED, ULL2NUM(system_ull("vm.stats.vm.v_reactivated")));
  rb_hash_aset(memory, SYM_PURGEABLE, Qnil);
  rb_hash_aset(memory, SYM_PURGED, Qnil);
  rb_hash_aset(memory, SYM_PAGEINS, Qnil);
  rb_hash_aset(memory, SYM_PAGEOUTS, Qnil);
  rb_hash_aset(memory, SYM_FAULTS, ULL2NUM(system_ull("vm.stats.vm.v_vm_faults")));
  rb_hash_aset(memory, SYM_COW_FAULTS, ULL2NUM(system_ull("vm.stats.vm.v_cow_faults")));
  rb_hash_aset(memory, SYM_LOOKUPS, Qnil);
  rb_hash_aset(memory, SYM_HITS, Qnil);
  
  return memory;
}
#elif __posix
    // POSIX
#endif

VALUE method_disk(VALUE self, VALUE path) {
  VALUE disk = Qnil;
  struct statfs stat;

  if (statfs(StringValueCStr(path), &stat) != -1) {
    disk = rb_hash_new();
    rb_hash_aset(disk, SYM_TYPE, ID2SYM(rb_intern(stat.f_fstypename)));
    rb_hash_aset(disk, SYM_ORIGIN, rb_str_new(stat.f_mntfromname, strlen(stat.f_mntfromname)));
    rb_hash_aset(disk, SYM_MOUNT, rb_str_new(stat.f_mntonname, strlen(stat.f_mntonname)));
    rb_hash_aset(disk, SYM_FREE_BYTES, ULL2NUM(stat.f_bfree * stat.f_bsize));
    rb_hash_aset(disk, SYM_AVAILABLE_BYTES, ULL2NUM(stat.f_bavail * stat.f_bsize));
    rb_hash_aset(disk, SYM_USED_BYTES, ULL2NUM((stat.f_blocks - stat.f_bfree) * stat.f_bsize));
    rb_hash_aset(disk, SYM_TOTAL_BYTES, ULL2NUM(stat.f_blocks * stat.f_bsize));
  }

  return disk;
}

#define AVGCOUNT 3
VALUE method_load_avg(VALUE self) {
  VALUE loads = rb_ary_new();
  double loadavg[AVGCOUNT];
  int i;

  getloadavg(&loadavg[0], AVGCOUNT);
  for(i = 0; i < AVGCOUNT; i++) {
    rb_ary_push(loads, rb_float_new(loadavg[i]));
  }

  return loads;
}

VALUE method_boot_time(VALUE self) {
  struct timeval tv;
  size_t size = sizeof(tv);
  static int which[] = { CTL_KERN, KERN_BOOTTIME };

  if (sysctl(which, 2, &tv, &size, NULL, 0) == 0) {
    return rb_time_new(tv.tv_sec, tv.tv_usec);
  } else {
    return Qnil;
  }
}

int system_int(const char * name) {
  int number;
  size_t number_size = sizeof(number);
  sysctlbyname(name, &number, &number_size, NULL, 0);
  return number;
}

unsigned long long system_ull(const char * name) {
  long number;
  size_t number_size = sizeof(number);
  if (sysctlbyname(name, &number, &number_size, NULL, 0) == -1) {
    perror("sysctlbyname");
    return -1;
  } else {
    return number;
  }
}
