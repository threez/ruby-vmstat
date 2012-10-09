require 'spec_helper'

describe Vmstat::Disk do
  context "Vmstat#disk" do
    let(:disk) { Vmstat.disk("/") }
    subject { disk }

    it "should be a vmstat disk object" do
      should be_a(Vmstat::Disk)
    end

    context "methods" do
      it { should respond_to(:type) }
      it { should respond_to(:origin) }
      it { should respond_to(:mount) }
      it { should respond_to(:free_bytes) }
      it { should respond_to(:available_bytes) }
      it { should respond_to(:used_bytes) }
      it { should respond_to(:total_bytes) }
    end
    
    context "content" do
      its(:type) { should be_a(Symbol) }
      its(:origin) { should be_a(String) }
      its(:mount) { should be_a(String) }
      its(:free_bytes) { should be_a_kind_of(Numeric) }
      its(:available_bytes) { should be_a_kind_of(Numeric) }
      its(:used_bytes) { should be_a_kind_of(Numeric) }
      its(:total_bytes) { should be_a_kind_of(Numeric) }
    end
  end
end
