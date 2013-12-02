require 'spec_helper'

describe SessionsController do

  describe "GET new" do

    it { should respond_to :new }

    it "should render the 'new' template" do
      get :new
      response.should render_template 'new'
    end
  end
end
