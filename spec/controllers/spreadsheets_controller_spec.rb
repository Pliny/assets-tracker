require 'spec_helper'

describe SpreadsheetsController do

  describe "GET 'index'" do

    it { should respond_to :index }

    it "should set active class to 'Tools' in header" do
      get :index
      assigns(:tool_active).should be_true
    end
  end

  describe "POST 'import'" do

    it { should respond_to :import }

  end
end
