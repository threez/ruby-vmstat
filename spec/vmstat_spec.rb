require 'spec_helper'
require 'ostruct'

describe Vmstat do
  context "#network" do
    let(:network) { Vmstat.network }

    it "should return the enthernet and loopback network data as hash" do
      network.should be_a(Hash)
    end

    context "loopback device" do
      let(:loopback) { network[:lo0] }
      subject { loopback }

      it "should contain the a loopback device info also as a hash" do
        should be_a(Hash)
      end

      context "keys" do
        it { should have_key(:in_bytes) }
        it { should have_key(:out_bytes) }
        it { should have_key(:in_errors) }
        it { should have_key(:out_errors) }
        it { should have_key(:in_drops) }
        it { should have_key(:type) }
      end

      context "type" do
        subject { OpenStruct.new loopback }

        its(:in_bytes) { should be_a_kind_of(Numeric) }
        its(:out_bytes) { should be_a_kind_of(Numeric) }
        its(:in_errors) { should be_a_kind_of(Numeric) }
        its(:out_errors) { should be_a_kind_of(Numeric) }
        its(:in_drops) { should be_a_kind_of(Numeric) }
        its(:type) { should be_a_kind_of(Numeric) }
      end
    end
  end

  context "#cpu" do
    let(:cpu) { Vmstat.cpu }

    it "should return an array of ethernet information" do
      cpu.should be_a(Array)
    end

    context "first cpu" do
      let(:first_cpu) { cpu.first }
      subject { first_cpu }

      it "should return a hash containing per cpu information" do
        should be_a(Hash)
      end

      context "keys" do
        it { should have_key(:user) }
        it { should have_key(:system) }
        it { should have_key(:nice) }
        it { should have_key(:idle) }
      end

      context "type" do
        subject { OpenStruct.new first_cpu }

        its(:user) { should be_a_kind_of(Numeric) }
        its(:system) { should be_a_kind_of(Numeric) }
        its(:nice) { should be_a_kind_of(Numeric) }
        its(:idle) { should be_a_kind_of(Numeric) }
      end
    end
  end

  context "#memory" do
    let(:memory) { Vmstat.memory }
    subject { memory }

    it "should be a hash of memory data" do
      should be_a(Hash)
    end

    context "keys" do
      it { should have_key(:pagesize) }
      it { should have_key(:wired) }
      it { should have_key(:active) }
      it { should have_key(:inactive) }
      it { should have_key(:free) }
      it { should have_key(:wired_bytes) }
      it { should have_key(:active_bytes) }
      it { should have_key(:inactive_bytes) }
      it { should have_key(:free_bytes) }
      it { should have_key(:zero_filled) }
      it { should have_key(:reactivated) }
      it { should have_key(:faults) }
      it { should have_key(:copy_on_write_faults) }
    end

    context "type" do
      subject { OpenStruct.new memory }

      its(:pagesize) { should be_a_kind_of(Numeric) }
      its(:wired) { should be_a_kind_of(Numeric) }
      its(:active) { should be_a_kind_of(Numeric) }
      its(:inactive) { should be_a_kind_of(Numeric) }
      its(:free) { should be_a_kind_of(Numeric) }
      its(:wired_bytes) { should be_a_kind_of(Numeric) }
      its(:active_bytes) { should be_a_kind_of(Numeric) }
      its(:inactive_bytes) { should be_a_kind_of(Numeric) }
      its(:free_bytes) { should be_a_kind_of(Numeric) }
      its(:zero_filled) { should be_a_kind_of(Numeric) }
      its(:reactivated) { should be_a_kind_of(Numeric) }
      its(:faults) { should be_a_kind_of(Numeric) }
      its(:copy_on_write_faults) { should be_a_kind_of(Numeric) }
    end
  end

  context "#disk" do
    let(:disk) { Vmstat.disk("/") }
    subject { disk }

    it "should be a hash of disk data" do
      should be_a(Hash)
    end

    context "keys" do
      it { should have_key(:type) }
      it { should have_key(:origin) }
      it { should have_key(:mount) }
      it { should have_key(:free_bytes) }
      it { should have_key(:available_bytes) }
      it { should have_key(:used_bytes) }
      it { should have_key(:total_bytes) }
    end
    
    context "type" do
      subject { OpenStruct.new disk }

      its(:type) { should be_a(Symbol) }
      its(:origin) { should be_a(String) }
      its(:mount) { should be_a(String) }
      its(:free_bytes) { should be_a_kind_of(Numeric) }
      its(:available_bytes) { should be_a_kind_of(Numeric) }
      its(:used_bytes) { should be_a_kind_of(Numeric) }
      its(:total_bytes) { should be_a_kind_of(Numeric) }
    end
  end

  context "#load_avg" do
    subject { Vmstat.load_avg }

    it "should be an array" do
      should be_a(Array)
    end

    it "should have three floats" do
      subject[0].should be_a(Float)
      subject[1].should be_a(Float)
      subject[2].should be_a(Float)
    end
  end

  context "#boot_time" do
    let(:boot_time) { Vmstat.boot_time }

    it "should be an array" do
      boot_time.should be_a(Time)
    end

    it "has to be a time before now" do
      boot_time.should < Time.now
    end
  end

  context "#filter_devices" do
    it "should filter ethernet devices" do
      Vmstat.ethernet_devices.size.should == 2
    end

    it "should filter loopback devices" do
      Vmstat.loopback_devices.size.should == 1
    end
  end
end
