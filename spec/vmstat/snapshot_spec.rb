require 'spec_helper'

describe Vmstat::Snapshot do
  context "Vmstat#snapshot" do
    let(:snapshot) { Vmstat.snapshot }
    subject { snapshot }

    it "should be an vmstat load snapshot object" do
      is_expected.to be_a(described_class)
    end

    context "methods" do
      it { is_expected.to respond_to(:at) }
      it { is_expected.to respond_to(:boot_time) }
      it { is_expected.to respond_to(:cpus) }
      it { is_expected.to respond_to(:disks) }
      it { is_expected.to respond_to(:load_average) }
      it { is_expected.to respond_to(:memory) }
      it { is_expected.to respond_to(:network_interfaces) }
      it { is_expected.to respond_to(:task) }
    end

    context "content" do
      describe '#at' do
        subject { super().at }
        it { is_expected.to be_a(Time) }
      end

      describe '#boot_time' do
        subject { super().boot_time }
        it { is_expected.to be_a(Time) }
      end

      describe '#cpus' do
        subject { super().cpus }
        it { is_expected.to be_a(Array) }
      end

      describe '#disks' do
        subject { super().disks }
        it { is_expected.to be_a(Array) }
      end

      describe '#load_average' do
        subject { super().load_average }
        it { is_expected.to be_a(Vmstat::LoadAverage) }
      end

      describe '#memory' do
        subject { super().memory }
        it { is_expected.to be_a(Vmstat::Memory) }
      end

      describe '#network_interfaces' do
        subject { super().network_interfaces }
        it { is_expected.to be_a(Array) }
      end
      if RUBY_PLATFORM =~ /darwin|linux/
        describe '#task' do
          subject { super().task }
          it { is_expected.to be_a(Vmstat::Task) }
        end
      end

      context "first of cpu" do
        subject { snapshot.cpus.first }
        it { is_expected.to be_a(Vmstat::Cpu) }
      end
      
      context "first of disks" do
        subject { snapshot.disks.first }
        it { is_expected.to be_a(Vmstat::Disk) }
      end

      context "first of network interfaces" do
        subject { snapshot.network_interfaces.first }
        it { is_expected.to be_a(Vmstat::NetworkInterface) }
      end
    end
  end
end
