#include <vmstat.h>

void Init_vmstat() {
  VALUE vmstat = rb_define_module("Vmstat");

  rb_define_singleton_method(vmstat, "network_interfaces", vmstat_network_interfaces, 0);
  rb_define_singleton_method(vmstat, "cpu", vmstat_cpu, 0);
  rb_define_singleton_method(vmstat, "memory", vmstat_memory, 0);
  rb_define_singleton_method(vmstat, "disk", vmstat_disk, 1);
  rb_define_singleton_method(vmstat, "load_average", vmstat_load_average, 0);
  rb_define_singleton_method(vmstat, "boot_time", vmstat_boot_time, 0);
#if defined(HAVE_MACH_MACH_H)
  rb_define_singleton_method(vmstat, "task", vmstat_task, 0);
#endif
}

#include <hw/mach.h>
#include <hw/statfs.h>
#include <hw/sysctl.h>
#include <hw/bsd.h>
