require 'spec_helper'

describe Asset do

  it { should respond_to :user }

  describe "validations" do

    it "should require a serial number" do
      Asset.new.should have(1).error_on :serial_no
    end

    it "should require a user" do
      Asset.new.should have(1).error_on :user_id
    end

    it "should have a unique serial number" do
      FactoryGirl.create(:asset, serial_no: "TEST")
      Asset.new(serial_no: "TEST").should have(1).error_on :serial_no
    end
  end

  describe ".import" do

    before do
      @file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
    end

    it "should import the xls file" do
      expect { Asset.import(@file) }.to change(Asset, :count).by 1
    end

    it "should update existing devices" do
      FactoryGirl.create(:asset, user_args: { full_name: "ray rodtusci" }, serial_no: "DEVFDXQZTCX3NMEHFDXM")
      expect { Asset.import(@file).should be_true }.to change(Asset, :count).by 0
      Asset.count.should == 1
      Asset.all.first.user.full_name.should == "Aron Rosenberg"
    end

    it "should set user to admin if Owner field is blank" do
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test_no_user.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
      Asset.import(file)
      Asset.all.first.user.should == User.find_by_full_name(ENV['ASSETS_ADMIN'])
    end

    it "should not try to create an entry on rows without device ids" do
      Asset.import(@file).should be_true
    end

    describe "attributes set" do

      before { Asset.import(@file) }

      it "should set the user" do
        User.all.first.full_name.should == "Aron Rosenberg"
      end

      it "should set the serial number" do
        Asset.all.first.serial_no.should == "DEVFDXQZTCX3NMEHFDXM"
      end

      it "should set the mac address" do
        Asset.all.first.mac_address.should == "D0:E7:82:EB:28:6D"
      end

      it "should set the notes" do
        Asset.all.first.notes.should == "ALPHA GROUP"
      end

      it "should set the 'in-house' boolean" do
        Asset.all.first.in_house.should be_true
      end
    end
  end

  describe ".open_spreadsheet" do

    before do
      @file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
    end

    it "should support .xlsx extensions" do
      Asset.open_spreadsheet(@file).should be_an_instance_of(Roo::Excelx)
    end
  end
end