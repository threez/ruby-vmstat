# frozen_string_literal: true

require 'spec_helper'

describe Vmstat::LinuxMemory do
  let(:procfs) do
    Class.new do
      extend Vmstat::ProcFS

      def self.procfs_path
        File.expand_path('../memavail_procfs', __dir__)
      end
    end
  end

  context '#memory' do
    subject { procfs.memory }

    it { is_expected.to be_a(Vmstat::LinuxMemory) }
    if `getconf PAGESIZE`.chomp.to_i == 4096
      it do
        is_expected.to eq(Vmstat::LinuxMemory.new(4096, 36_522, 326_978,
                                                  44_494, 63_113, 64_599, 1104))
      end

      it 'should have the right total' do
        expect(subject.wired_bytes + subject.active_bytes +
         subject.inactive_bytes + subject.free_bytes).to eq(1_929_654_272)
      end
    end
  end
end
