require 'spec_helper'

describe SessionsController do

  describe "GET new" do

    it { should respond_to :new }

    it "should render the 'new' template" do
      get :new
      response.should render_template 'new'
    end
  end

  describe "DELETE 'destroy'" do

    it { should respond_to :destroy }

    it "should sign out the user" do
      subject.should_receive(:sign_out).once
      delete :destroy
      response.should redirect_to signin_path
    end
  end
end
