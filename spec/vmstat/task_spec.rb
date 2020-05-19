require 'spec_helper'

describe Vmstat::Task do
  context "Vmstat#task" do
    let(:task) { Vmstat.task }
    subject { task }

    it "should be a vmstat task object" do
      is_expected.to be_a(described_class)
    end

    context "methods" do
      it { is_expected.to respond_to(:virtual_size) }
      it { is_expected.to respond_to(:resident_size) }
      it { is_expected.to respond_to(:user_time_ms) }
      it { is_expected.to respond_to(:system_time_ms) }
    end
    
    context "content" do
      describe '#virtual_size' do
        subject { super().virtual_size }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#resident_size' do
        subject { super().resident_size }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#user_time_ms' do
        subject { super().user_time_ms }
        it { is_expected.to be_a_kind_of(Numeric) }
      end

      describe '#system_time_ms' do
        subject { super().system_time_ms }
        it { is_expected.to be_a_kind_of(Numeric) }
      end
    end
  end
end if RUBY_PLATFORM =~ /darwin|linux/

