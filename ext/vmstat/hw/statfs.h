#if defined(HAVE_SYS_PARAM_H) && defined(HAVE_SYS_MOUNT_H) && defined(HAVE_STATFS)
#include <vmstat.h>
#include <sys/param.h>
#include <sys/mount.h>

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
#endif
