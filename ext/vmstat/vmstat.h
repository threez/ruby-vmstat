#include <ruby.h>

#define AVGCOUNT 3

VALUE vmstat = Qnil;
VALUE vmstat_network_interfaces(VALUE self);
VALUE vmstat_cpu(VALUE self);
VALUE vmstat_memory(VALUE self);
VALUE vmstat_disk(VALUE self, VALUE path);
VALUE vmstat_load_average(VALUE self);
VALUE vmstat_boot_time(VALUE self);

#if defined(__APPLE__)
VALUE vmstat_task(VALUE self);
#endif
