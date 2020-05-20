# frozen_string_literal: true

require 'spec_helper'

describe Vmstat::Solaris do
  let(:solaris) do
    c = Vmstat::Solaris

    def c.`(cmd)
      if cmd == 'kstat -p "cpu_stat:::/idle|kernel|user/"'
        "cpu_stat:0:cpu_stat0:idle       2325343762
cpu_stat:0:cpu_stat0:idlethread 776439232
cpu_stat:0:cpu_stat0:kernel     89137335
cpu_stat:0:cpu_stat0:kernel_asflt       1
cpu_stat:0:cpu_stat0:user       64919001
cpu_stat:1:cpu_stat1:idle       2322767706
cpu_stat:1:cpu_stat1:idlethread 125993797
cpu_stat:1:cpu_stat1:kernel     78457429
cpu_stat:1:cpu_stat1:kernel_asflt       34
cpu_stat:1:cpu_stat1:user       78174710
cpu_stat:2:cpu_stat2:idle       2390178542
cpu_stat:2:cpu_stat2:idlethread 3368087417
cpu_stat:2:cpu_stat2:kernel     50617796
cpu_stat:2:cpu_stat2:kernel_asflt       0
cpu_stat:2:cpu_stat2:user       38603497
cpu_stat:3:cpu_stat3:idle       2390802861
cpu_stat:3:cpu_stat3:idlethread 1772145290
cpu_stat:3:cpu_stat3:kernel     46044221
cpu_stat:3:cpu_stat3:kernel_asflt       0
cpu_stat:3:cpu_stat3:user       42552751
cpu_stat:4:cpu_stat4:idle       2436590263
cpu_stat:4:cpu_stat4:idlethread 2145015281
cpu_stat:4:cpu_stat4:kernel     23983506
cpu_stat:4:cpu_stat4:kernel_asflt       0
cpu_stat:4:cpu_stat4:user       18826062
cpu_stat:5:cpu_stat5:idle       2435969240
cpu_stat:5:cpu_stat5:idlethread 3720145695
cpu_stat:5:cpu_stat5:kernel     25630307
cpu_stat:5:cpu_stat5:kernel_asflt       0
cpu_stat:5:cpu_stat5:user       17800281
cpu_stat:6:cpu_stat6:idle       2432659504
cpu_stat:6:cpu_stat6:idlethread 3012624014
cpu_stat:6:cpu_stat6:kernel     24414413
cpu_stat:6:cpu_stat6:kernel_asflt       0
cpu_stat:6:cpu_stat6:user       22325909
cpu_stat:7:cpu_stat7:idle       2430409364
cpu_stat:7:cpu_stat7:idlethread 1931519381
cpu_stat:7:cpu_stat7:kernel     28094309
cpu_stat:7:cpu_stat7:kernel_asflt       0
cpu_stat:7:cpu_stat7:user       20896150
cpu_stat:8:cpu_stat8:idle       2443187236
cpu_stat:8:cpu_stat8:idlethread 1900014542
cpu_stat:8:cpu_stat8:kernel     20799721
cpu_stat:8:cpu_stat8:kernel_asflt       0
cpu_stat:8:cpu_stat8:user       15412864
cpu_stat:9:cpu_stat9:idle       2440596009
cpu_stat:9:cpu_stat9:idlethread 3703869451
cpu_stat:9:cpu_stat9:kernel     23787482
cpu_stat:9:cpu_stat9:kernel_asflt       0
cpu_stat:9:cpu_stat9:user       15016328
cpu_stat:10:cpu_stat10:idle     2427567910
cpu_stat:10:cpu_stat10:idlethread       3191481058
cpu_stat:10:cpu_stat10:kernel   30059932
cpu_stat:10:cpu_stat10:kernel_asflt     5
cpu_stat:10:cpu_stat10:user     21771975
cpu_stat:11:cpu_stat11:idle     2431827979
cpu_stat:11:cpu_stat11:idlethread       1824361353
cpu_stat:11:cpu_stat11:kernel   27388335
cpu_stat:11:cpu_stat11:kernel_asflt     0
cpu_stat:11:cpu_stat11:user     20183500
cpu_stat:12:cpu_stat12:idle     2442824569
cpu_stat:12:cpu_stat12:idlethread       2037054756
cpu_stat:12:cpu_stat12:kernel   21276397
cpu_stat:12:cpu_stat12:kernel_asflt     0
cpu_stat:12:cpu_stat12:user     15298846
cpu_stat:13:cpu_stat13:idle     2443388458
cpu_stat:13:cpu_stat13:idlethread       3442886390
cpu_stat:13:cpu_stat13:kernel   22081759
cpu_stat:13:cpu_stat13:kernel_asflt     0
cpu_stat:13:cpu_stat13:user     13929592
cpu_stat:14:cpu_stat14:idle     2434768696
cpu_stat:14:cpu_stat14:idlethread       2856867656
cpu_stat:14:cpu_stat14:kernel   23352419
cpu_stat:14:cpu_stat14:kernel_asflt     0
cpu_stat:14:cpu_stat14:user     21278693
cpu_stat:15:cpu_stat15:idle     2432514522
cpu_stat:15:cpu_stat15:idlethread       1703823954
cpu_stat:15:cpu_stat15:kernel   27050642
cpu_stat:15:cpu_stat15:kernel_asflt     16
cpu_stat:15:cpu_stat15:user     19834642
cpu_stat:16:cpu_stat16:idle     2436582325
cpu_stat:16:cpu_stat16:idlethread       1983802071
cpu_stat:16:cpu_stat16:kernel   21833225
cpu_stat:16:cpu_stat16:kernel_asflt     0
cpu_stat:16:cpu_stat16:user     20984253
cpu_stat:17:cpu_stat17:idle     2432250902
cpu_stat:17:cpu_stat17:idlethread       307297399
cpu_stat:17:cpu_stat17:kernel   29580663
cpu_stat:17:cpu_stat17:kernel_asflt     0
cpu_stat:17:cpu_stat17:user     17568236
cpu_stat:18:cpu_stat18:idle     2447310538
cpu_stat:18:cpu_stat18:idlethread       1473510287
cpu_stat:18:cpu_stat18:kernel   18480841
cpu_stat:18:cpu_stat18:kernel_asflt     5
cpu_stat:18:cpu_stat18:user     13608419
cpu_stat:19:cpu_stat19:idle     2446462748
cpu_stat:19:cpu_stat19:idlethread       2882237650
cpu_stat:19:cpu_stat19:kernel   20384068
cpu_stat:19:cpu_stat19:kernel_asflt     0
cpu_stat:19:cpu_stat19:user     12552980
cpu_stat:20:cpu_stat20:idle     2439710143
cpu_stat:20:cpu_stat20:idlethread       2513415319
cpu_stat:20:cpu_stat20:kernel   20976077
cpu_stat:20:cpu_stat20:kernel_asflt     0
cpu_stat:20:cpu_stat20:user     18713575
cpu_stat:21:cpu_stat21:idle     2434565830
cpu_stat:21:cpu_stat21:idlethread       1574993351
cpu_stat:21:cpu_stat21:kernel   26063716
cpu_stat:21:cpu_stat21:kernel_asflt     0
cpu_stat:21:cpu_stat21:user     18770245
cpu_stat:22:cpu_stat22:idle     2447896586
cpu_stat:22:cpu_stat22:idlethread       1566290884
cpu_stat:22:cpu_stat22:kernel   18718466
cpu_stat:22:cpu_stat22:kernel_asflt     0
cpu_stat:22:cpu_stat22:user     12784738
cpu_stat:23:cpu_stat23:idle     2444823222
cpu_stat:23:cpu_stat23:idlethread       3286395080
cpu_stat:23:cpu_stat23:kernel   21510594
cpu_stat:23:cpu_stat23:kernel_asflt     0
cpu_stat:23:cpu_stat23:user     13065972
cpu_stat:24:cpu_stat24:idle     2437316848
cpu_stat:24:cpu_stat24:idlethread       2628739060
cpu_stat:24:cpu_stat24:kernel   22266295
cpu_stat:24:cpu_stat24:kernel_asflt     0
cpu_stat:24:cpu_stat24:user     19816643
cpu_stat:25:cpu_stat25:idle     2433451000
cpu_stat:25:cpu_stat25:idlethread       1604646150
cpu_stat:25:cpu_stat25:kernel   26748441
cpu_stat:25:cpu_stat25:kernel_asflt     0
cpu_stat:25:cpu_stat25:user     19200341
cpu_stat:26:cpu_stat26:idle     2446405472
cpu_stat:26:cpu_stat26:idlethread       1573139378
cpu_stat:26:cpu_stat26:kernel   19619834
cpu_stat:26:cpu_stat26:kernel_asflt     0
cpu_stat:26:cpu_stat26:user     13374474
cpu_stat:27:cpu_stat27:idle     2444019515
cpu_stat:27:cpu_stat27:idlethread       3275705315
cpu_stat:27:cpu_stat27:kernel   21816225
cpu_stat:27:cpu_stat27:kernel_asflt     0
cpu_stat:27:cpu_stat27:user     13564039
cpu_stat:28:cpu_stat28:idle     2435784523
cpu_stat:28:cpu_stat28:idlethread       2628201319
cpu_stat:28:cpu_stat28:kernel   23125551
cpu_stat:28:cpu_stat28:kernel_asflt     0
cpu_stat:28:cpu_stat28:user     20489701
cpu_stat:29:cpu_stat29:idle     2432230501
cpu_stat:29:cpu_stat29:idlethread       1635408506
cpu_stat:29:cpu_stat29:kernel   27198273
cpu_stat:29:cpu_stat29:kernel_asflt     0
cpu_stat:29:cpu_stat29:user     19970999
cpu_stat:30:cpu_stat30:idle     2444413183
cpu_stat:30:cpu_stat30:idlethread       1644573224
cpu_stat:30:cpu_stat30:kernel   20310412
cpu_stat:30:cpu_stat30:kernel_asflt     0
cpu_stat:30:cpu_stat30:user     14676176
cpu_stat:31:cpu_stat31:idle     2442483106
cpu_stat:31:cpu_stat31:idlethread       3345414215
cpu_stat:31:cpu_stat31:kernel   22515695
cpu_stat:31:cpu_stat31:kernel_asflt     0
cpu_stat:31:cpu_stat31:user     14400967\n"
      elsif cmd == 'kstat -p unix:::boot_time'
        "unix:0:system_misc:boot_time     1470765992\n"
      elsif cmd == 'kstat -p -n system_pages'
        "unix:0:system_pages:availrmem     70121
unix:0:system_pages:crtime        116.1198523
unix:0:system_pages:desfree       3744
unix:0:system_pages:desscan       25
unix:0:system_pages:econtig       176160768
unix:0:system_pages:fastscan      137738
unix:0:system_pages:freemem       61103
unix:0:system_pages:kernelbase    16777216
unix:0:system_pages:lotsfree      7488
unix:0:system_pages:minfree       1872
unix:0:system_pages:nalloc        26859076
unix:0:system_pages:nalloc_calls  11831
unix:0:system_pages:nfree         25250198
unix:0:system_pages:nfree_calls   7888
unix:0:system_pages:nscan         0
unix:0:system_pages:pagesfree     61103
unix:0:system_pages:pageslocked   409145
unix:0:system_pages:pagestotal    479266
unix:0:system_pages:physmem       489586
unix:0:system_pages:pp_kernel     438675
unix:0:system_pages:slowscan      100
unix:0:system_pages:snaptime      314313.3248461\n"
      elsif cmd == 'kstat -p link:::'
        "link:0:e1000g0:ierrors 0
link:0:e1000g0:oerrors 1
link:0:e1000g0:rbytes64 1000
link:0:e1000g0:obytes64 2000\n"
      else
        raise "Unknown cmd: '#{cmd}'"
      end
    end
    c
  end

  context '#cpu' do
    subject { solaris.cpu }

    it { is_expected.to be_a(Array) }
    it do
      is_expected.to eq([
                          Vmstat::Cpu.new(0, 64_919_001, 89_137_335, 0, 2_325_343_762),
                          Vmstat::Cpu.new(1, 78_174_710, 78_457_429, 0, 2_322_767_706),
                          Vmstat::Cpu.new(2, 38_603_497, 50_617_796, 0, 2_390_178_542),
                          Vmstat::Cpu.new(3, 42_552_751, 46_044_221, 0, 2_390_802_861),
                          Vmstat::Cpu.new(4, 18_826_062, 23_983_506, 0, 2_436_590_263),
                          Vmstat::Cpu.new(5, 17_800_281, 25_630_307, 0, 2_435_969_240),
                          Vmstat::Cpu.new(6, 22_325_909, 24_414_413, 0, 2_432_659_504),
                          Vmstat::Cpu.new(7, 20_896_150, 28_094_309, 0, 2_430_409_364),
                          Vmstat::Cpu.new(8, 15_412_864, 20_799_721, 0, 2_443_187_236),
                          Vmstat::Cpu.new(9, 15_016_328, 23_787_482, 0, 2_440_596_009),
                          Vmstat::Cpu.new(10, 21_771_975, 30_059_932, 0, 2_427_567_910),
                          Vmstat::Cpu.new(11, 20_183_500, 27_388_335, 0, 2_431_827_979),
                          Vmstat::Cpu.new(12, 15_298_846, 21_276_397, 0, 2_442_824_569),
                          Vmstat::Cpu.new(13, 13_929_592, 22_081_759, 0, 2_443_388_458),
                          Vmstat::Cpu.new(14, 21_278_693, 23_352_419, 0, 2_434_768_696),
                          Vmstat::Cpu.new(15, 19_834_642, 27_050_642, 0, 2_432_514_522),
                          Vmstat::Cpu.new(16, 20_984_253, 21_833_225, 0, 2_436_582_325),
                          Vmstat::Cpu.new(17, 17_568_236, 29_580_663, 0, 2_432_250_902),
                          Vmstat::Cpu.new(18, 13_608_419, 18_480_841, 0, 2_447_310_538),
                          Vmstat::Cpu.new(19, 12_552_980, 20_384_068, 0, 2_446_462_748),
                          Vmstat::Cpu.new(20, 18_713_575, 20_976_077, 0, 2_439_710_143),
                          Vmstat::Cpu.new(21, 18_770_245, 26_063_716, 0, 2_434_565_830),
                          Vmstat::Cpu.new(22, 12_784_738, 18_718_466, 0, 2_447_896_586),
                          Vmstat::Cpu.new(23, 13_065_972, 21_510_594, 0, 2_444_823_222),
                          Vmstat::Cpu.new(24, 19_816_643, 22_266_295, 0, 2_437_316_848),
                          Vmstat::Cpu.new(25, 19_200_341, 26_748_441, 0, 2_433_451_000),
                          Vmstat::Cpu.new(26, 13_374_474, 19_619_834, 0, 2_446_405_472),
                          Vmstat::Cpu.new(27, 13_564_039, 21_816_225, 0, 2_444_019_515),
                          Vmstat::Cpu.new(28, 20_489_701, 23_125_551, 0, 2_435_784_523),
                          Vmstat::Cpu.new(29, 19_970_999, 27_198_273, 0, 2_432_230_501),
                          Vmstat::Cpu.new(30, 14_676_176, 20_310_412, 0, 2_444_413_183),
                          Vmstat::Cpu.new(31, 14_400_967, 22_515_695, 0, 2_442_483_106)
                        ])
    end
  end

  context '#memory' do
    subject { solaris.memory }

    it { is_expected.to be_a(Vmstat::Memory) }
    if `getconf PAGESIZE`.chomp.to_i == 4096
      it do
        is_expected.to eq(Vmstat::Memory.new(4096, 409_145, 9018, 0, 61_103, 0, 0))
      end
    end
  end

  context '#boot_time' do
    subject { solaris.boot_time }

    it { is_expected.to be_a(Time) }
    it { is_expected.to eq(Time.at(1_470_765_992)) }
  end

  context '#network_interfaces' do
    subject { solaris.network_interfaces }

    it { is_expected.to be_a(Array) }
    it do
      is_expected.to eq([
                          Vmstat::NetworkInterface.new(:e1000g0, 1000, 0, 0, 2000, 1,
                                                       Vmstat::NetworkInterface::ETHERNET_TYPE)
                        ])
    end
  end
end
