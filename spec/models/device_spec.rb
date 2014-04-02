require 'spec_helper'

describe Device do

  it { should respond_to :user }

  it { should respond_to :hardware_version }

  describe "validations" do

    it "should require a serial number" do
      Device.new.should have(1).error_on :serial_no
    end

    it "should require a user" do
      Device.new.should have(1).error_on :user_id
    end

    it "should have a unique serial number" do
      FactoryGirl.create(:device, serial_no: "TEST")
      Device.new(serial_no: "TEST").should have(1).error_on :serial_no
    end

    it "should have a hardware version" do
      FactoryGirl.create(:hardware_version, name: "asdf", project: "qwer")
      Device.new.should have(1).error_on :hardware_version_id
    end

    it "should have a valid IPv4 address, if exists"

    it "should have a valid unique MAC address, if exists"
  end

  describe ".import" do

    before do
      @file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
    end

    it "should import the xls file" do
      expect { Device.import(@file) }.to change(Device, :count).by 1
    end

    it "should update existing devices" do
      FactoryGirl.create(:device, user_args: { full_name: "ray rodtusci" }, serial_no: "DEVFDXQZTCX3NMEHFDXM")
      expect { Device.import(@file).should be_true }.to change(Device, :count).by 0
      Device.count.should == 1
      Device.all.first.user.full_name.should == "Aron Rosenberg"
    end

    it "should set user to admin if Owner field is blank" do
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test_no_user.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
      Device.import(file)
      Device.all.first.user.should == User.find_by_full_name(ENV['ASSETS_ADMIN'])
    end

    it "should not try to create an entry on rows without device ids" do
      Device.import(@file).should be_true
    end

    it "should find existing hardware verison" do
      hardware_version = FactoryGirl.create(:hardware_version, name: "PreDVT", project: "Tiburon")
      Device.import(@file)
      Device.all.first.hardware_version.should == hardware_version
    end

    it "should gracefully error on people with first names only" do
      errors = []
      file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/first_name_only.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
      expect { errors = Device.import(file) }.to change(Device, :count).by 0
      errors.should == ["Row 3 in AppendList sheet has error related to the Owner 'Last name can't be blank'"]
    end

    describe "return value" do

      before do
        @admin = ENV['ASSETS_ADMIN']
        ENV['ASSETS_ADMIN'] = nil
      end

      after  { ENV['ASSETS_ADMIN'] = @admin}

      it "should describe all failed database insertion attempts" do
        file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test_no_user.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
        Device.import(file).should == [ "Row 3 in AppendList sheet has error 'User can't be blank'" ]
      end
    end

    describe "attributes set" do

      before { Device.import(@file) }

      it "should set the user" do
        User.all.first.full_name.should == "Aron Rosenberg"
      end

      it "should set the serial number" do
        Device.all.first.serial_no.should == "DEVFDXQZTCX3NMEHFDXM"
      end

      it "should set the mac address" do
        Device.all.first.mac_address.should == "D0:E7:82:EB:28:6D"
      end

      it "should set the notes" do
        Device.all.first.notes.should == "ALPHA GROUP"
      end

      it "should set the 'in-house' boolean" do
        Device.all.first.in_house.should be_true
      end

      it "should set the hardware version" do
        Device.all.first.hardware_version.should == HardwareVersion.all.first
      end
    end

    describe "versioning", versioning: true do

      it "should be enabled here" do
        PaperTrail.should be_enabled
      end

      it "should start the history when created" do
        expect { Device.import(@file) }.to change(PaperTrail::Version, :count).by 1
      end
    end
  end

  describe ".open_spreadsheet" do

    before do
      @file = Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/simple_test.xlsx'), ' application/vnd.ms-excel.sheet.macroenabled.12')
    end

    it "should support .xlsx extensions" do
      Device.open_spreadsheet(@file).should be_an_instance_of(Roo::Excelx)
    end
  end

  describe ".search" do

    it "should return list of devices" do
      device = FactoryGirl.create(:device, serial_no: "DEV1234")
      result = Device.search("DEV1234").to_a
      result.should_not be_nil
      result.length.should == 1
      result.should == [ device ]
    end

    it "should check for parts of the serial number" do
      device1 = FactoryGirl.create(:device, serial_no: "DEV1234")
      device2 = FactoryGirl.create(:device, serial_no: "4345EV533")
      result = Device.search("EV").to_a
      result.should_not be_nil
      result.length.should == 2
      result.should == [ device1, device2 ]
    end
  end
end
