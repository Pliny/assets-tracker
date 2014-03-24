require 'spec_helper'

describe Asset do

  it { should respond_to :user }

  it { should respond_to :hardware_version }

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

    it "should have a hardware version" do
      FactoryGirl.create(:hardware_version, name: "asdf", project: "qwer")
      Asset.new.should have(1).error_on :hardware_version_id
    end

    it "should have a valid IPv4 address, if exists"

    it "should have a valid unique MAC address, if exists"
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

    it "should find existing hardware verison" do
      hardware_version = FactoryGirl.create(:hardware_version, name: "PreDVT", project: "Tiburon")
      Asset.import(@file)
      Asset.all.first.hardware_version.should == hardware_version
    end

    describe "return value" do

      before do
        @admin = ENV['ASSETS_ADMIN']
        ENV['ASSETS_ADMIN'] = nil
      end

      after  { ENV['ASSETS_ADMIN'] = @admin}

      it "should describe all failed database insertion attempts" do
        file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test_no_user.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
        Asset.import(file).should == [ "Row 3 in AppendList sheet has error 'User can't be blank'" ]
      end
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

      it "should set the hardware version" do
        Asset.all.first.hardware_version.should == HardwareVersion.all.first
      end
    end

    describe "versioning", versioning: true do

      it "should be enabled here" do
        PaperTrail.should be_enabled
      end

      it "should start the history when created" do
        expect { Asset.import(@file) }.to change(PaperTrail::Version, :count).by 1
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
