require 'spec_helper'

describe Vmstat::Disk do
  context "sample" do
    let(:disk) { described_class.new :hfs, "/dev/disk0", "/mnt/test",
                                     4096, 100, 200, 600 }
    subject { disk }

    describe '#type' do
      subject { super().type }
      it { is_expected.to eq(:hfs) }
    end

    describe '#origin' do
      subject { super().origin }
      it { is_expected.to eq("/dev/disk0") }
    end

    describe '#mount' do
      subject { super().mount }
      it { is_expected.to eq("/mnt/test") }
    end

    describe '#block_size' do
      subject { super().block_size }
      it { is_expected.to eq(4096) }
    end

    describe '#free_blocks' do
      subject { super().free_blocks }
      it { is_expected.to eq(100) }
    end

    describe '#available_blocks' do
      subject { super().available_blocks }
      it { is_expected.to eq(200) }
    end

    describe '#total_blocks' do
      subject { super().total_blocks }
      it { is_expected.to eq(600) }
    end

    describe '#free_bytes' do
      subject { super().free_bytes }
      it { is_expected.to eq(409600) }
    end

    describe '#available_bytes' do
      subject { super().available_bytes }
      it { is_expected.to eq(819200) }
    end

    describe '#used_bytes' do
      subject { super().used_bytes }
      it { is_expected.to eq(2048000) }
    end

    describe '#total_bytes' do
      subject { super().total_bytes }
      it { is_expected.to eq(2457600) }
    end
  end

  context "Vmstat#disk" do
    let(:disk) { Vmstat.disk("/") }
    subject { disk }

    it "should be a vmstat disk object" do
      is_expected.to be_a(described_class)
    end

    context "methods" do
      it { is_expected.to respond_to(:type) }
      it { is_expected.to respond_to(:origin) }
      it { is_expected.to respond_to(:mount) }
      it { is_expected.to respond_to(:free_bytes) }
      it { is_expected.to respond_to(:available_bytes) }
      it { is_expected.to respond_to(:used_bytes) }
      it { is_expected.to respond_to(:total_bytes) }
    end
    
    context "content" do
      # inside docker we may not have directory mounted on
      # a physical drive
      unless docker?
        describe '#type' do
          subject { super().type }
          it { is_expected.to be_a(Symbol) }
        end
      end

      describe '#origin' do
        subject { super().origin }
        it { is_expected.to be_a(String) }
      end

      describe '#mount' do
        subject { super().mount }
        it { is_expected.to be_a(String) }
      end

      describe '#free_bytes' do
        subject { super().free_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#available_bytes' do
        subject { super().available_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#used_bytes' do
        subject { super().used_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#total_bytes' do
        subject { super().total_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end
    end
  end
end
