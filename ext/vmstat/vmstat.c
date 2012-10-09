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
#include <mach/mach_host.h>
#endif
#include <vmstat.h>

// helper methodsd
int system_int(const char *);
unsigned long long system_ull(const char *);

void Init_vmstat() {
  vmstat = rb_define_module("Vmstat");

  rb_define_singleton_method(vmstat, "network_interfaces", vmstat_network_interfaces, 0);
  rb_define_singleton_method(vmstat, "cpu", vmstat_cpu, 0);
  rb_define_singleton_method(vmstat, "memory", vmstat_memory, 0);
  rb_define_singleton_method(vmstat, "disk", vmstat_disk, 1);
  rb_define_singleton_method(vmstat, "load_average", vmstat_load_average, 0);
  rb_define_singleton_method(vmstat, "boot_time", vmstat_boot_time, 0);
#if defined(__APPLE__)
  rb_define_singleton_method(vmstat, "task", vmstat_task, 0);
#endif
}

VALUE vmstat_network_interfaces(VALUE self) {
  VALUE devices = rb_ary_new();
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
      VALUE device = rb_funcall(rb_path2class("Vmstat::NetworkInterface"),
                     rb_intern("new"), 7, ID2SYM(rb_intern(mibdata.ifmd_name)),
                                          ULL2NUM(mibdata.ifmd_data.ifi_ibytes),
                                          ULL2NUM(mibdata.ifmd_data.ifi_ierrors),
                                          ULL2NUM(mibdata.ifmd_data.ifi_iqdrops),
                                          ULL2NUM(mibdata.ifmd_data.ifi_obytes),
                                          ULL2NUM(mibdata.ifmd_data.ifi_oerrors),
                                          ULL2NUM(mibdata.ifmd_data.ifi_type));

      rb_ary_push(devices, device);
    }
  }

  return devices;
}

#if defined(__APPLE__)
VALUE vmstat_cpu(VALUE self) {
  VALUE cpus = rb_ary_new();
  processor_info_array_t cpuInfo;
  mach_msg_type_number_t numCpuInfo;
  natural_t numCPUsU = 0U;
  kern_return_t err = host_processor_info(mach_host_self(),
    PROCESSOR_CPU_LOAD_INFO, &numCPUsU, &cpuInfo, &numCpuInfo);

  if(err == KERN_SUCCESS) {
    unsigned i;

    for(i = 0U; i < numCPUsU; ++i) {
      int pos = CPU_STATE_MAX * i;
      VALUE cpu = rb_funcall(rb_path2class("Vmstat::Cpu"),
                  rb_intern("new"), 5, ULL2NUM(i),
                                       ULL2NUM(cpuInfo[pos + CPU_STATE_USER]),
                                       ULL2NUM(cpuInfo[pos + CPU_STATE_SYSTEM]),
                                       ULL2NUM(cpuInfo[pos + CPU_STATE_NICE]),
                                       ULL2NUM(cpuInfo[pos + CPU_STATE_IDLE]));
      rb_ary_push(cpus, cpu);
    }

    err = vm_deallocate(mach_task_self(), (vm_address_t)cpuInfo,
                        (vm_size_t)sizeof(*cpuInfo) * numCpuInfo);
    if (err != KERN_SUCCESS) {
      rb_bug("vm_deallocate: %s\n", mach_error_string(err));
    }
  }
  
  return cpus;
}

VALUE vmstat_memory(VALUE self) {
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
      memory = rb_funcall(rb_path2class("Vmstat::Memory"),
               rb_intern("new"), 15, ULL2NUM(pagesize),
                                     ULL2NUM(vm_stat.active_count),
                                     ULL2NUM(vm_stat.inactive_count),
                                     ULL2NUM(vm_stat.wire_count),
                                     ULL2NUM(vm_stat.free_count),
                                     ULL2NUM(vm_stat.pageins),
                                     ULL2NUM(vm_stat.pageouts),
                                     ULL2NUM(vm_stat.zero_fill_count),
                                     ULL2NUM(vm_stat.reactivations),
                                     ULL2NUM(vm_stat.purgeable_count),
                                     ULL2NUM(vm_stat.purges),
                                     ULL2NUM(vm_stat.faults),
                                     ULL2NUM(vm_stat.cow_faults),
                                     ULL2NUM(vm_stat.lookups),
                                     ULL2NUM(vm_stat.hits));
    }

    err = vm_deallocate(mach_task_self(), (vm_address_t)pagesize,
                        (vm_size_t)host_count);
    if (err != KERN_SUCCESS) {
      rb_bug("vm_deallocate: %s\n", mach_error_string(err));
    }
  }

  return memory;
}

VALUE vmstat_task(VALUE self) {
  VALUE task = Qnil;
  struct task_basic_info info;
  kern_return_t err;
  mach_msg_type_number_t size = sizeof(info);

  err = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
  if (err == KERN_SUCCESS) {
    task = rb_funcall(rb_path2class("Vmstat::Task"),
           rb_intern("new"), 5, LONG2NUM(info.suspend_count),
                                LONG2NUM(info.virtual_size),
                                LONG2NUM(info.resident_size),
                                LONG2NUM(info.user_time.seconds * 1000 + info.user_time.microseconds),
                                LONG2NUM(info.system_time.seconds * 1000 + info.system_time.microseconds));
  } else {
    rb_bug("task_info: %s\n", mach_error_string(err));
  }

  return task;
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

VALUE vmstat_cpu(VALUE self) {
  VALUE cpus = rb_ary_new();
  int cpu_count = system_int("hw.ncpu");
  size_t len = sizeof(cpu_time_t) * cpu_count;
  cpu_time_t * cp_times = ALLOC_N(cpu_time_t, cpu_count);
  cpu_time_t * cp_time;
  int i;
  
  if (sysctlbyname("kern.cp_times", cp_times, &len, NULL, 0) == 0) {
    for (i = 0; i < cpu_count; i++) {
      cp_time = &cp_times[i];
      VALUE cpu = rb_funcall(rb_path2class("Vmstat::Cpu"),
                  rb_intern("new"), 5, ULL2NUM(i),
                                       ULL2NUM(cp_time->user),
                                       ULL2NUM(cp_time->system + cp_time->intr),
                                       ULL2NUM(cp_time->nice),
                                       ULL2NUM(cp_time->idle));
      rb_ary_push(cpus, cpu);
    }
  }

  free(cp_times);
  
  return cpus;
}

VALUE vmstat_memory(VALUE self) {
  VALUE memory = rb_funcall(rb_path2class("Vmstat::Memory"),
                 rb_intern("new"), 15, ULL2NUM(system_ull("vm.stats.vm.v_page_size")),
                                       ULL2NUM(system_ull("vm.stats.vm.v_active_count")),
                                       ULL2NUM(system_ull("vm.stats.vm.v_wire_count")),
                                       ULL2NUM(system_ull("vm.stats.vm.v_inactive_count")),
                                       ULL2NUM(system_ull("vm.stats.vm.v_free_count")),
                                       ULL2NUM(Qnil),
                                       ULL2NUM(Qnil),
                                       ULL2NUM(system_ull("vm.stats.misc.zero_page_count")),
                                       ULL2NUM(system_ull("vm.stats.vm.v_reactivated")),
                                       ULL2NUM(Qnil),
                                       ULL2NUM(Qnil),
                                       ULL2NUM(system_ull("vm.stats.vm.v_vm_faults")),
                                       ULL2NUM(system_ull("vm.stats.vm.v_cow_faults")),
                                       ULL2NUM(Qnil),
                                       ULL2NUM(Qnil));
  return memory;
}
#elif __posix
    // POSIX
#endif

VALUE vmstat_disk(VALUE self, VALUE path) {
  VALUE disk = Qnil;
  struct statfs stat;

  if (statfs(StringValueCStr(path), &stat) != -1) {
    disk = rb_funcall(rb_path2class("Vmstat::Disk"),
           rb_intern("new"), 7, ID2SYM(rb_intern(stat.f_fstypename)),
                                rb_str_new(stat.f_mntfromname, strlen(stat.f_mntfromname)),
                                rb_str_new(stat.f_mntonname, strlen(stat.f_mntonname)),
                                ULL2NUM(stat.f_bsize),
                                ULL2NUM(stat.f_bfree),
                                ULL2NUM(stat.f_bavail),
                                ULL2NUM(stat.f_blocks));
  }

  return disk;
}

VALUE vmstat_load_average(VALUE self) {
  VALUE load = Qnil;
  double loadavg[AVGCOUNT];

  getloadavg(&loadavg[0], AVGCOUNT);

  load = rb_funcall(rb_path2class("Vmstat::LoadAverage"),
         rb_intern("new"), 3, rb_float_new(loadavg[0]),
                              rb_float_new(loadavg[1]),
                              rb_float_new(loadavg[2]));

  return load;
}

static int BOOT_TIME_MIB[] = { CTL_KERN, KERN_BOOTTIME };

VALUE vmstat_boot_time(VALUE self) {
  struct timeval tv;
  size_t size = sizeof(tv);

  if (sysctl(BOOT_TIME_MIB, 2, &tv, &size, NULL, 0) == 0) {
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
