# frozen_string_literal: true

module Vmstat
  # Since on linux the type and mount information are note available in the
  # statfs library, we have to use constants to find out the file system type.
  # The mount point and the path will allways be the same, because we don't have
  # the mount information. But one can still either use the device or mountpoint
  # to get the information.
  class LinuxDisk < Disk
    # Mapping of file system type codes to file system names.
    FS_CODES = {
      44_533 => :adfs, 44_543 => :affs, 1_111_905_073 => :befs, 464_386_766 => :bfs,
      4_283_649_346 => :cifs_number, 1_937_076_805 => :coda, 19_920_823 => :coh,
      684_539_205 => :cramfs, 4979 => :devfs, 4_278_867 => :efs, 4989 => :ext,
      61_265 => :ext2_old, 61_267 => :ext4, 16_964 => :hfs, 4_187_351_113 => :hpfs,
      2_508_478_710 => :hugetlbfs, 38_496 => :isofs, 29_366 => :jffs2,
      827_541_066 => :jfs, 4991 => :minix, 9320 => :minix2, 9336 => :minix22,
      19_780 => :msdos, 22_092 => :ncp, 26_985 => :nfs, 1_397_118_030 => :ntfs_sb,
      40_865 => :openprom, 40_864 => :proc, 47 => :qnx4, 1_382_369_651 => :reiserfs,
      29_301 => :romfs, 20_859 => :smb, 19_920_822 => :sysv2, 19_920_821 => :sysv4,
      16_914_836 => :tmpfs, 352_400_198 => :udf, 72_020 => :ufs, 7377 => :devpts,
      40_866 => :usbdevice, 2_768_370_933 => :vxfs, 19_920_820 => :xenix, 1_481_003_842 => :xfs,
      19_911_021 => :xiafs, 1_448_756_819 => :reiserfs, 1_650_812_274 => :sysfs
    }.freeze

    # Mainly a wrapper for the {Vmstat::Disk} class constructor. This constructor
    # handles the file system type mapping (based on the magic codes defined in
    # {LinuxDisk::FS_CODES}).
    # @param [Fixnum] fs the type or magix number of the disk.
    # @param [String] path the path to the disk
    # @param [Fixnum] block_size size of a file system block
    # @param [Fixnum] free_blocks the number of free blocks
    # @param [Fixnum] available_blocks the number of available blocks
    # @param [Fixnum] total_blocks the number of total blocks
    def initialize(fs = nil, path = nil, block_size = nil, free_blocks = nil,
                   available_blocks = nil, total_blocks = nil)
      @fs = fs
      super FS_CODES[@fs], path, path, block_size,
            free_blocks, available_blocks, total_blocks
    end
  end
end
