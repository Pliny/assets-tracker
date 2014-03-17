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

    before do
      @file = fixture_file_upload("files/simple_test.xlsx", 'application/vnd.ms-excel.sheet.macroenabled.12')
    end

    it { should respond_to :import }

    describe "successfully" do

      before do
        Asset.should_receive(:import).with(an_instance_of(Rack::Test::UploadedFile)).once.and_return(true)
      end

      it "should redirect to root page" do
        post :import, "spreadsheet-file" => @file
        response.should redirect_to root_path
      end

      it "should import xls data" do
        post :import, "spreadsheet-file" => @file
      end
    end

    describe "unsuccessfully" do

      before do
        Asset.should_receive(:import).with(an_instance_of(Rack::Test::UploadedFile)).once.and_return(false)
      end

      it "should return client error" do
        post :import, "spreadsheet-file" => @file
        response.should be_bad_request
      end
    end
  end
end
