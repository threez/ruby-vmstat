require 'spec_helper'

describe Vmstat::LinuxMemory do
  let(:procfs) do
    Class.new do
      extend Vmstat::ProcFS

      def self.procfs_path
        File.expand_path("../../memavail_procfs", __FILE__)
      end
    end
  end

  context "#memory" do
    subject { procfs.memory }
    
    it { is_expected.to be_a(Vmstat::LinuxMemory) }
    if `getconf PAGESIZE`.chomp.to_i == 4096
      it do
        is_expected.to eq(Vmstat::LinuxMemory.new(4096, 36522, 326978, 
                                          44494, 63113, 64599, 1104))
      end

      it "should have the right total" do
        expect(subject.wired_bytes + subject.active_bytes +
         subject.inactive_bytes + subject.free_bytes).to eq(1929654272)
      end
    end
  end
end

