require 'spec_helper'

describe ApplicationHelper do

  describe "title" do

    it "should include the page title" do
      title("foo").should =~ /foo/
    end

    it "should include the base title" do
      title("foo").should =~ /^Assets Tracker/
    end

    it "should not include a bar for the home page" do
      title("").should_not =~ /\|/
    end
  end

  describe "flash to bootstrap" do

    it "should convert :notice to bootstrap friendly class" do
      flash_class(:notice).should == "alert alert-info"
    end

    it "should convert :success to bootstrap friendly class" do
      flash_class(:success).should == "alert alert-success"
    end

    it "should convert :alert to bootstrap friendly class" do
      flash_class(:alert).should == "alert alert-warning"
    end

    it "should convert :error to bootstrap friendly class" do
      flash_class(:error).should == "alert alert-danger"
    end
  end
end

