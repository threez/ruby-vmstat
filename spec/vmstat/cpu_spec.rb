require 'spec_helper'

describe Vmstat::Cpu do
  context "Vmstat#cpu" do
    let(:cpu) { Vmstat.cpu }

    it "should return an array of ethernet information" do
      expect(cpu).to be_a(Array)
    end

    context "first cpu" do
      let(:first_cpu) { cpu.first }
      subject { first_cpu }

      it "should return a vmstat cpu object" do
        is_expected.to be_a(described_class)
      end

      context "methods" do
        it { is_expected.to respond_to(:user) }
        it { is_expected.to respond_to(:system) }
        it { is_expected.to respond_to(:nice) }
        it { is_expected.to respond_to(:idle) }
      end

      context "content" do
        describe '#user' do
          subject { super().user }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#system' do
          subject { super().system }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#nice' do
          subject { super().nice }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#idle' do
          subject { super().idle }
          it { is_expected.to be_a_kind_of(Numeric) }
        end
      end
    end
  end
end
