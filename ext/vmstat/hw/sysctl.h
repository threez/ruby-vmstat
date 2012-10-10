#if defined(HAVE_SYS_SYSCTL_H) && \
    defined(HAVE_SYS_TYPES_H) && \
    defined(HAVE_SYS_SOCKET_H) && \
    defined(HAVE_NET_IF_H) && \
    defined(HAVE_NET_IF_MIB_H) && \
    defined(HAVE_NET_IF_TYPES_H) && \
    defined(HAVE_GETLOADAVG) && \
    defined(HAVE_SYSCTL) && \
    defined(HAVE_TYPE_STRUCT_IFMIBDATA) && \
    defined(HAVE_CONST_CTL_NET) && \
    defined(HAVE_CONST_PF_LINK) && \
    defined(HAVE_CONST_NETLINK_GENERIC) && \
    defined(HAVE_CONST_IFMIB_IFDATA) && \
    defined(HAVE_CONST_IFDATA_GENERAL) && \
    defined(HAVE_CONST_CTL_KERN) && \
    defined(HAVE_CONST_KERN_BOOTTIME)
#include <vmstat.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>
#include <net/if_mib.h>
#include <net/if_types.h>

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
#endif
