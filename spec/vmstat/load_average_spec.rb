require 'spec_helper'

describe Vmstat::LoadAverage do
  context "Vmstat#load_average" do
    subject { Vmstat.load_average }

    it "should be an vmstat load average object" do
      is_expected.to be_a(described_class)
    end

    context "methods" do
      it { is_expected.to respond_to(:one_minute) }
      it { is_expected.to respond_to(:five_minutes) }
      it { is_expected.to respond_to(:fifteen_minutes) }
    end

    context "content" do
      describe '#one_minute' do
        subject { super().one_minute }
        it { is_expected.to be_a(Float) }
      end

      describe '#five_minutes' do
        subject { super().five_minutes }
        it { is_expected.to be_a(Float) }
      end

      describe '#fifteen_minutes' do
        subject { super().fifteen_minutes }
        it { is_expected.to be_a(Float) }
      end
    end
  end
end
