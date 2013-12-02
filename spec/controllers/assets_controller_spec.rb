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
end
