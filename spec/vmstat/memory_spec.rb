require 'spec_helper'

describe Vmstat::Memory do
  context "sample" do
    let(:disk) { described_class.new 4096, 775581, 196146, 437495, 685599,
                                     1560532, 0 }
    subject { disk }

    describe '#pagesize' do
      subject { super().pagesize }
      it { is_expected.to eq(4096) }
    end

    describe '#wired' do
      subject { super().wired }
      it { is_expected.to eq(775581) }
    end

    describe '#active' do
      subject { super().active }
      it { is_expected.to eq(196146) }
    end

    describe '#inactive' do
      subject { super().inactive }
      it { is_expected.to eq(437495) }
    end

    describe '#free' do
      subject { super().free }
      it { is_expected.to eq(685599) }
    end

    describe '#wired_bytes' do
      subject { super().wired_bytes }
      it { is_expected.to eq(3176779776) }
    end

    describe '#active_bytes' do
      subject { super().active_bytes }
      it { is_expected.to eq(803414016) }
    end

    describe '#inactive_bytes' do
      subject { super().inactive_bytes }
      it { is_expected.to eq(1791979520) }
    end

    describe '#free_bytes' do
      subject { super().free_bytes }
      it { is_expected.to eq(2808213504) }
    end

    describe '#total_bytes' do
      subject { super().total_bytes }
      it { is_expected.to eq(8580386816) }
    end

    describe '#pageins' do
      subject { super().pageins }
      it { is_expected.to eq(1560532) }
    end

    describe '#pageouts' do
      subject { super().pageouts }
      it { is_expected.to eq(0) }
    end
  end

  context "Vmstat#memory" do
    let(:memory) { Vmstat.memory }
    subject { memory }

    it "should be a vmstat memory object" do
      is_expected.to be_a(described_class)
    end

    context "methods" do
      it { is_expected.to respond_to(:pagesize) }
      it { is_expected.to respond_to(:wired) }
      it { is_expected.to respond_to(:active) }
      it { is_expected.to respond_to(:inactive) }
      it { is_expected.to respond_to(:free) }
      it { is_expected.to respond_to(:pageins) }
      it { is_expected.to respond_to(:pageouts) }

      it { is_expected.to respond_to(:wired_bytes) }
      it { is_expected.to respond_to(:active_bytes) }
      it { is_expected.to respond_to(:inactive_bytes) }
      it { is_expected.to respond_to(:free_bytes) }
      it { is_expected.to respond_to(:total_bytes)}
    end

    context "content" do
      describe '#pagesize' do
        subject { super().pagesize }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#wired' do
        subject { super().wired }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#active' do
        subject { super().active }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#inactive' do
        subject { super().inactive }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#free' do
        subject { super().free }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#pageins' do
        subject { super().pageins }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#pageouts' do
        subject { super().pageouts }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#wired_bytes' do
        subject { super().wired_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#active_bytes' do
        subject { super().active_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#inactive_bytes' do
        subject { super().inactive_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#free_bytes' do
        subject { super().free_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#total_bytes' do
        subject { super().total_bytes }
        it { is_expected.to be_a_kind_of(Numeric) }
      end
    end
  end
end
