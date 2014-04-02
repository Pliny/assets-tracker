require 'spec_helper'

describe DevicesController do

  describe "GET index" do

    it { should respond_to :index }

    describe "Anonymous user" do

      it "should show the signin page" do
        get :index
        response.should redirect_to signin_path
      end
    end
  end

  describe "GET edit" do

    before do
      @device = FactoryGirl.create(:device)
    end

    it { should respond_to :edit }

    describe "logged in user" do

      before { login }

      it "should return 404 if device is not found" do
        get :edit, id: (@device.id+1)
        response.should be_not_found
      end
    end

    describe "Anonymous user" do

      it "should show the signin page" do
        get :edit, id: @device
        response.should redirect_to signin_path
      end
    end
  end

  describe "POST update" do

    before do
      @device = FactoryGirl.create(:device, serial_no: "DEFAULT", in_house: false)
    end

    it { should respond_to :update }

    describe "logged in user" do

      before { login }

      it "should return 404 if device is not found" do
        post :update, id: (@device.id+1), device: { serial_no: "TEST" }
        response.should be_not_found
      end

      it "should redirect to the device index on successful update" do
        post :update, id: @device, device: { serial_no: "TEST" }
        response.should redirect_to device_path(@device)
      end

      describe "validation failures" do

        it "should redirect to edit page on device update failure" do
          post :update, id: @device, device: { serial_no: "" }
          response.should render_template :edit
        end

        it "should fail if hardware version is not found" do
          post :update, id: @device, device: { hardware_version: {name: "bla", project: "blue"} }
          response.should render_template :edit
        end

        it "should fail if user is not found" do
          post :update, id: @device, device: { user: { full_name: "bdsa dska" } }
          response.should render_template :edit
        end
      end

      describe "attributes to update" do

        before do
          FactoryGirl.create(:user, first_name: "User", last_name: "UPDATED")
          FactoryGirl.create(:hardware_version, name: "name UPDATED", project: "Project UPDATED")
          post :update, id: @device, device: {
            serial_no: "Serial Number UPDATED",
            user: { full_name: "User UPDATED" },
            mac_address: "FF:FF:FF:FF:FF",
            ipv4_address: "192.168.1.1",
            notes: "Notes UPDATED",
            in_house: "1",
            hardware_version: { name: "name UPDATED", project: "Project UPDATED"}
          }
        end

        it "should update the serial number" do
          @device.reload.serial_no.should == "Serial Number UPDATED"
        end

        it "should update the user" do
          @device.reload.user.full_name.should  == "User UPDATED".titleize
        end

        it "should update the MAC address" do
          @device.reload.mac_address.should == "FF:FF:FF:FF:FF"
        end

        it "should update the IPv4 address" do
          @device.reload.ipv4_address.should ==  "192.168.1.1"
        end

        it "should update the notes" do
          @device.reload.notes.should == "Notes UPDATED"
        end

        it "should update whether or not the unit is on site" do
          @device.reload.in_house.should be_true
        end

        it "should update the hardware verion information" do
          @device.reload.hardware_version.name.should == "name UPDATED"
          @device.reload.hardware_version.project.should == "Project UPDATED"
        end
      end
    end

    describe "anonymous user" do

      it "should show the signin page" do
        post :update, id: @device, device: { serial_no: "TEST" }
        response.should redirect_to signin_path
      end
    end
  end

  describe "GET show" do

    it {should respond_to :show}

    describe "Anonymous user" do

      it "should show the signin page" do
        get :show, id: FactoryGirl.create(:device)
        response.should redirect_to signin_path
      end
    end
  end

  describe "GET new" do

    it { should respond_to :new }

    describe "Anonymous user" do

      it "should show the signin page" do
        get :new
        response.should redirect_to signin_path
      end
    end
  end

  describe "POST create" do

    it { should respond_to :create }

    describe "logged in user" do

      before do
        login
      end

      def create_device
        post :create, device: {
          serial_no: "DEV1234",
          hardware_version_id: FactoryGirl.create(:hardware_version),
          user: { full_name: FactoryGirl.create(:user).full_name }
        }
      end

      it "should redirect to show on successful create" do
        create_device
        response.should redirect_to device_path(Device.all.first)
      end

      it "should create an device" do
        expect {
          create_device
        }.to change(Device, :count).by 1
      end

      it "should redirect to new page on failure" do
        post :create, device: { serial_no: "DEV1234", user: { full_name: ""} }
        response.should render_template 'new'
      end
    end

    describe "Anonymous user" do

      it "should show the signin page" do
        post :create
        response.should redirect_to signin_path
      end
    end
  end

  describe "GET search" do

    it { should respond_to :search }

    describe "logged in user" do

      before do
        login
      end

      it "should show single device item if one item was found" do
        device = FactoryGirl.create(:device, serial_no: "DEV4321")
        get :search, asset: { search: "DEV" }
        response.should render_template :show
      end

      it "should show all devices if many items exist" do
        device1 = FactoryGirl.create(:device, serial_no: "DEV1234")
        device2 = FactoryGirl.create(:device, serial_no: "DEV4321")
        get :search, asset: { search: "DEV" }
        response.should render_template :index
      end

      it "should render flash if no devices were found" do
        get :search, asset: { search: "DEV" }
        response.should render_template :index
        controller.flash[:error].should ==  "No devices found with query string 'DEV'"
      end
    end

    describe "Anonymous user" do

      it "should show the signin page" do
        get :search, asset: { search: "DEV" }
        response.should redirect_to signin_path
      end
    end

  end
end
