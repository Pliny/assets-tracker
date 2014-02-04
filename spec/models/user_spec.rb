require 'spec_helper'

describe User do

  before do
    @user = User.new(first_name: "Example User", email: 'dibbleboggins@example.com')
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
end
