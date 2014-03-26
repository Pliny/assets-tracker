require 'spec_helper'

describe AssetsController do

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
      @asset = FactoryGirl.create(:asset)
    end

    it { should respond_to :edit }

    describe "logged in user" do

      before { login }

      it "should return 404 if asset is not found" do
        get :edit, id: (@asset.id+1)
        response.should be_not_found
      end
    end

    describe "Anonymous user" do

      it "should show the signin page" do
        get :edit, id: @asset
        response.should redirect_to signin_path
      end
    end
  end

  describe "POST update" do

    before do
      @asset = FactoryGirl.create(:asset, serial_no: "DEFAULT", in_house: false)
    end

    it { should respond_to :update }

    describe "logged in user" do

      before { login }

      it "should return 404 if asset is not found" do
        post :update, id: (@asset.id+1), asset: { serial_no: "TEST" }
        response.should be_not_found
      end

      it "should redirect to the asset index on successful update" do
        post :update, id: @asset, asset: { serial_no: "TEST" }
        response.should redirect_to assets_path
      end

      describe "validation failures" do

        it "should redirect to edit page on asset update failure" do
          post :update, id: @asset, asset: { serial_no: "" }
          response.should render_template :edit
        end

        it "should fail if hardware version is not found" do
          post :update, id: @asset, asset: { hardware_version: {name: "bla", project: "blue"} }
          response.should render_template :edit
        end

        it "should fail if user is not found" do
          post :update, id: @asset, asset: { user: { full_name: "bdsa dska" } }
          response.should render_template :edit
        end
      end

      describe "attributes to update" do

        before do
          FactoryGirl.create(:user, first_name: "User", last_name: "UPDATED")
          FactoryGirl.create(:hardware_version, name: "name UPDATED", project: "Project UPDATED")
          post :update, id: @asset, asset: {
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
          @asset.reload.serial_no.should == "Serial Number UPDATED"
        end

        it "should update the user" do
          @asset.reload.user.full_name.should  == "User UPDATED".titleize
        end

        it "should update the MAC address" do
          @asset.reload.mac_address.should == "FF:FF:FF:FF:FF"
        end

        it "should update the IPv4 address" do
          @asset.reload.ipv4_address.should ==  "192.168.1.1"
        end

        it "should update the notes" do
          @asset.reload.notes.should == "Notes UPDATED"
        end

        it "should update whether or not the unit is on site" do
          @asset.reload.in_house.should be_true
        end

        it "should update the hardware verion information" do
          @asset.reload.hardware_version.name.should == "name UPDATED"
          @asset.reload.hardware_version.project.should == "Project UPDATED"
        end
      end

      pending "should redirect to the asset itself"

    end

    describe "anonymous user" do

      it "should show the signin page" do
        post :update, id: @asset, asset: { serial_no: "TEST" }
        response.should redirect_to signin_path
      end
    end
  end

  describe "GET show" do

    it {should respond_to :show}

    describe "Anonymous user" do

      it "should show the signin page" do
        get :show, id: FactoryGirl.create(:asset)
        response.should redirect_to signin_path
      end
    end
  end
end
