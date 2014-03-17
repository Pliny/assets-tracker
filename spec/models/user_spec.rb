require 'spec_helper'

describe User do

  before do
    @user = User.new(first_name: "Example", last_name: "user", email: 'dibbleboggins@example.com')
  end

  subject { @user }

  it { should respond_to(:remember_token) }

  it { should respond_to(:google_id) }
  it { should respond_to(:google_token) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:email) }
  it { should respond_to(:google_hd) }
  it { should respond_to(:google_image_url) }

  it { should respond_to(:assets) }

  describe "validations" do

    it "should require an email" do
      User.new.should have(1).error_on :email
    end

    it "should have a first name" do
      User.new.should have(1).error_on :first_name
    end

    it "should have a valid email" do
      user = User.new(email: 'dave examplecom')
      user.should have(1).error_on :email
    end

    it "should have a unique email" do
      FactoryGirl.create(:user, email: 'hi@example.com')
      User.new(email: 'hi@example.com').should have(1).error_on :email
    end
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "titleize name" do

    before { @user.save }

    it "should titlelize all names before saving" do
      @user.first_name.should == @user.first_name.titleize
      @user.last_name.should == @user.last_name.titleize
    end
  end

  describe "#full_name" do

    it "should return first and last name" do
      user = FactoryGirl.create(:user, first_name: "Dave", last_name: "Docomotion", email: 'hi@example.com')
      user.full_name.should == "Dave Docomotion"
    end

    it "should titleize the name" do
      user = FactoryGirl.create(:user, first_name: "dave", last_name: "docomotion", email: 'hi@example.com')
      user.full_name.should == "Dave Docomotion"
    end
  end

  describe ".find_by_full_name" do

    it "should find user object by full name" do
      user = FactoryGirl.create(:user, first_name: "dodd", last_name: "mctafferly")
      User.find_by_full_name("Dodd Mctafferly").should == user
    end

    it "should handle multiple spaces in the name" do
      user = FactoryGirl.create(:user, first_name: "two names", last_name: "mcgoo")
      User.find_by_full_name("two names mcgoo".titleize).should == user
    end
  end

  describe ".create_by_full_name" do

    it "should create a new user and give a temporary email" do
      lambda do
        User.create_by_full_name! "Dude lamina"
      end.should change(User, :count).by 1
    end
  end
end
