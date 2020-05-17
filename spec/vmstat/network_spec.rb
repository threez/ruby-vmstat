require 'spec_helper'

describe Vmstat::NetworkInterface do
  context "Vmstat#network" do
    let(:network) { Vmstat.network_interfaces }

    it "should return the enthernet and loopback network data as an array" do
      expect(network).to be_a(Array)
    end

    context "loopback device" do
      let(:loopback) { network.find { |interface| interface.loopback? } }
      subject { loopback }

      it "should be a vmstat network interface object" do
        is_expected.to be_a(described_class)
      end

      context "methods" do
        it { is_expected.to respond_to(:in_bytes) }
        it { is_expected.to respond_to(:out_bytes) }
        it { is_expected.to respond_to(:in_errors) }
        it { is_expected.to respond_to(:out_errors) }
        it { is_expected.to respond_to(:in_drops) }
        it { is_expected.to respond_to(:type) }
      end

      context "content" do
        describe '#in_bytes' do
          subject { super().in_bytes }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#out_bytes' do
          subject { super().out_bytes }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#in_errors' do
          subject { super().in_errors }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#out_errors' do
          subject { super().out_errors }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#in_drops' do
          subject { super().in_drops }
          it { is_expected.to be_a_kind_of(Numeric) }
        end

        describe '#type' do
          subject { super().type }
          it { is_expected.to be_a_kind_of(Numeric) }
        end
      end
    end
  end
end
