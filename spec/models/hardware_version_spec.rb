require 'spec_helper'

describe HardwareVersion do

  describe "validations" do

    it "should require the name" do
      HardwareVersion.new.should have(1).error_on :name
    end

    it "should have a unique name given the same project" do
      FactoryGirl.create(:hardware_version, project: "ASDF", name: "BLABLA")
      HardwareVersion.new(name: "BLABLA", project: "ASDF").should have(1).error_on :name
    end

    it "should allow same name with different projects" do
      FactoryGirl.create(:hardware_version, project: "ASDF", name: "BLABLA")
      HardwareVersion.new(name: "BLABLA", project: "QWER").should have(0).errors_on :name
    end

    it "should require the project" do
      HardwareVersion.new.should have(1).error_on :project
    end

    it "should be case insensitive on name" do
      FactoryGirl.create(:hardware_version, name: "BLAbLa", project: "ASDF")
      HardwareVersion.new(name: "blablA", project: "ASDF").should have(1).error_on :name
    end
  end

  it { should respond_to :display }
end
