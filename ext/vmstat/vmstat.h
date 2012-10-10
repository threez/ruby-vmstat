#include <ruby.h>

#ifndef _VMSTAT_H_
#define _VMSTAT_H_

#define AVGCOUNT 3

VALUE vmstat_network_interfaces(VALUE self);
VALUE vmstat_cpu(VALUE self);
VALUE vmstat_memory(VALUE self);
VALUE vmstat_disk(VALUE self, VALUE path);
VALUE vmstat_load_average(VALUE self);
VALUE vmstat_boot_time(VALUE self);

#if defined(__APPLE__)
VALUE vmstat_task(VALUE self);
#endif

#endif /* _VMSTAT_H_ */
