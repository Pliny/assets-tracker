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
end

