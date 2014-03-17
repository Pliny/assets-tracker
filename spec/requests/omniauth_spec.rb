require 'spec_helper'

describe "login from web" do

  def auth_via_google
    get "/auth/google_oauth2"
    response.should be_redirect
    follow_redirect!
  end

  it "should have google oauth link" do
    get signin_path
    response.body.should =~ /href="auth\/google_oauth2"/
  end

  context "with a valid omniauth response" do

    before { setup_google_omniauth }

    it "should be redirect back to home" do
      get "/auth/google_oauth2"
      response.should be_redirect
      follow_redirect!
      response.should be_redirect
      response.should redirect_to("http://www.example.com/")
    end

    context "when the Google user has never logged in before" do

      context "and is allowed to log in" do

        context "but has a temporary email" do

          it "should update the email" do
            user = FactoryGirl.create(:user, email: "asdf@#{ENV['EMAIL_SERVER']}", first_name: 'Fixture First Name', last_name: 'Fixture Last Name')
            auth_via_google
            user.reload.email.should == "dude@example.com"
          end
        end

        it "should create a google user" do
          expect { auth_via_google }.to change(User, :count).by 1
        end

        it "should log in a new user" do
          auth_via_google
          assigns(:current_user).google_id.should == "12345"
        end

        it "should store the Google username with the current user" do
          auth_via_google

          assigns(:current_user).first_name.should == "Fixture First Name"
          assigns(:current_user).last_name.should == "Fixture Last Name"
        end

        it "should store the Google photo url with the current user" do
          auth_via_google
          assigns(:current_user).google_image_url.should == "https://fixture/google/profile/image/url.gif"
        end
      end

      context "and is not allowed to log in" do

        before do
          ENV['EMAIL_SERVER'] = "badexample.com"
        end

        after do
          ENV['EMAIL_SERVER'] = "example.com"
        end

        it "should not create a google user" do
          expect { auth_via_google }.to change(User, :count).by 0
        end

        it "should flash a notice to the unauthorized user" do
          auth_via_google
          response.should redirect_to('http://www.example.com/signin')
          follow_redirect!

          Nokogiri::HTML(response.body).css('.alert-danger').inner_html.strip.should =~ /Sorry, you must be part of this group to create an account/
        end
      end
    end

    context "when the Google user has logged in before" do

      it "should log in the user with that Google ID" do
        google_user = FactoryGirl.create(:user, email: 'dude@example.com')
        auth_via_google
        assigns(:current_user).id.should == google_user.id
      end
    end
  end

  context "with an invalid omniauth response" do

    before do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_credentials
    end

    it "shows validation errors" do
      auth_via_google
      response.should be_redirect
      follow_redirect!
      response.should redirect_to('http://www.example.com/signin')
      follow_redirect!

      Nokogiri::HTML(response.body).css('.alert-danger').inner_html.strip.should =~ /Sorry, something went wrong with the login\./
    end
  end
end
