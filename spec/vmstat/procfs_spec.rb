# frozen_string_literal: true

require 'spec_helper'

describe Vmstat::ProcFS do
  let(:procfs) do
    Class.new do
      extend Vmstat::ProcFS

      def self.procfs_path
        File.expand_path('../procfs', __dir__)
      end
    end
  end
  subject { procfs }

  context '#cpu' do
    subject { procfs.cpu }

    it { is_expected.to be_a(Array) }
    it do
      is_expected.to eq([
                          Vmstat::Cpu.new(0, 311, 966, 0, 26_788),
                          Vmstat::Cpu.new(1, 351, 862, 0, 27_263),
                          Vmstat::Cpu.new(2, 324, 1092, 0, 26_698),
                          Vmstat::Cpu.new(30, 326, 838, 0, 27_581)
                        ])
    end
  end

  context '#memory' do
    subject { procfs.memory }

    it { is_expected.to be_a(Vmstat::Memory) }
    if `getconf PAGESIZE`.chomp.to_i == 4096
      it do
        is_expected.to eq(Vmstat::Memory.new(4096, 4906, 6508, 8405, 107_017, 64_599, 1104))
      end

      it 'should have the right total' do
        expect(subject.wired_bytes + subject.active_bytes +
         subject.inactive_bytes + subject.free_bytes).to eq(507_344 * 1024)
      end
    end
  end

  context '#boot_time' do
    subject { procfs.boot_time }

    it { is_expected.to be_a(Time) }
    it { Timecop.freeze(Time.now) { is_expected.to eq(Time.now - 355.63) } }
  end

  context '#network_interfaces' do
    subject { procfs.network_interfaces }

    it { is_expected.to be_a(Array) }
    it do
      is_expected.to eq([
                          Vmstat::NetworkInterface.new(:lo, 3224, 0, 0, 3224, 0,
                                                       Vmstat::NetworkInterface::LOOPBACK_TYPE),
                          Vmstat::NetworkInterface.new(:eth1, 0, 1, 2, 0, 3,
                                                       Vmstat::NetworkInterface::ETHERNET_TYPE),
                          Vmstat::NetworkInterface.new(:eth0, 33_660, 0, 0, 36_584, 0,
                                                       Vmstat::NetworkInterface::ETHERNET_TYPE)
                        ])
    end
  end

  context '#task' do
    subject { procfs.task }

    it { is_expected.to be_a(Vmstat::Task) }
    if `getconf PAGESIZE`.chomp.to_i == 4096
      it { is_expected.to eq(Vmstat::Task.new(4807, 515, 2000, 0)) }
    end
  end
end
