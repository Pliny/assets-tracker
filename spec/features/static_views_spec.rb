require 'spec_helper'

describe "Static Views" do

  subject { page.body }

  describe "common elements" do

    before do
      visit root_path
    end

    it { should have_selector('.navbar-header a.navbar-brand')}

    it "should have the App name" do
      find('.navbar-header a.navbar-brand').should have_content("Asset Tracker")
    end

    describe "anonymous user" do

      it { should have_selector('body > .container > .google-signin')}
    end

    describe "logged in user", versioning: true do

      before do
        integration_login(first_name: "dude", last_name: "Mctalis", email: "dude@example.com")
        PaperTrail.whodunnit = (User.all.first)
        FactoryGirl.create(:asset)
        PaperTrail.whodunnit = nil
        visit root_path
      end

      it { should have_selector(".panel")}
    end
  end

  describe "User sessions" do

    describe "when logged in" do

      before do
        integration_login(first_name: "dude", last_name: "Mctalis", email: "dude@example.com")
        visit root_path
      end

      it "should have a signout link" do
        find(".navbar-nav li > a[href=\"#{signout_path}\"]").should have_content("Logout")
      end

      it "should have the current user's full name" do
        find(".navbar-nav > li.dropdown > a").should have_content("Dude Mctalis")
      end

      it "should show the 'Tools' option" do
        find(".navbar-nav:first > li > a.dropdown-toggle").should have_content("Tools")
      end
    end

    describe "when not logged in" do

      before { visit root_path }

      it "should have a signin link" do
        find(".navbar-nav > li > a[href=\"#{signin_path}\"]").should have_content("Log in")
      end

      it "should not show the 'Tools' option" do
        page.should have_no_selector(:css, ".navbar-nav:first > li > a.dropdown-toggle")
      end
    end
  end

  describe "importing" do

    before do
      visit spreadsheets_path
    end

    it { should be }
  end

  describe "pagination" do

    before do
      integration_login
    end

    it "should paginate assets" do
      3.times { FactoryGirl.create(:asset) }
      visit assets_path
      all(".panel-primary").length.should == 2
    end

    it "should paginate to the second page of assets when instructed" do
      Timecop.freeze(Time.now-1.day)
      FactoryGirl.create(:asset, serial_no: "TEST")
      Timecop.return
      2.times { FactoryGirl.create(:asset) }
      visit assets_path(page: 2)
      all(".panel-primary > .panel-body > h3").length.should == 1
      find(".panel-primary > .panel-body > h3").should have_content "TEST"
    end

    it "should have a link at the bottom" do
      3.times { FactoryGirl.create(:asset) }
      visit assets_path
      find(".pagination").should be_true
    end

    it "should paginate versions", versioning: true do
      Timecop.freeze(Time.now-1.day)
      FactoryGirl.create(:asset, serial_no: "TEST")
      Timecop.return
      2.times { FactoryGirl.create(:asset) }
      visit versions_path(page: 2)
      all(".panel-primary").length.should == 1
      find(".panel-primary > .panel-body").should have_content "TEST"
      find(".pagination").should be_true
    end
  end

  describe "editing an existing asset" do

    before { integration_login }

    it "should exist" do
      asset = FactoryGirl.create(:asset)
      visit edit_asset_path(asset)
      find('form').should be_true
    end

    it "should edit the asset" do
      asset = FactoryGirl.create(:asset)
      visit edit_asset_path(asset)
      fill_in "Serial Number", with: "BLABLA"
      click_on "Update"
      current_path.should == assets_path
      asset.reload.serial_no.should == "BLABLA"
    end

    it "should handle bad input graciously" do
      asset = FactoryGirl.create(:asset)
      visit edit_asset_path(asset)
      fill_in "Serial Number", with: ""
      fill_in "Owner", with: "asdssssf"
      fill_in "Hardware Version", with: "qweqwer"
      fill_in "Project", with: "dksae"
      fill_in "MAC Address", with: "1234"
      fill_in "IPv4 Address", with: "765rd"
      click_on "Update"
      current_path.should == asset_path(asset)
      page.has_selector?('.has-error')
    end

    it "should redirect to the asset page"
  end
end

