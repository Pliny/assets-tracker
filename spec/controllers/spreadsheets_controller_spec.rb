require 'spec_helper'

describe SpreadsheetsController do

  describe "GET 'index'" do

    it { should respond_to :index }

    describe "logged in user" do

      before { login }

      it "should set active class to 'Tools' in header" do
        get :index
        assigns(:tool_active).should be_true
      end

      it "should not set version metadata", versioning: true do
        PaperTrail.should be_enabled
        controller.should_not_receive(:info_for_paper_trail)
        get :index
      end
    end

    describe "anonymous user" do

      it "should not be allowed" do
        get :index
        response.should redirect_to signin_path
      end
    end
  end

  describe "POST 'import'" do

    describe "logged in user" do

      before do
        @user = login
        @file = fixture_file_upload("files/simple_test.xlsx", 'application/vnd.ms-excel.sheet.macroenabled.12')
      end

      it { should respond_to :import }

      it "should create a fully populated versioning information", versioning: true do
        post :import, "spreadsheet-file" => @file
        Asset.all.first.originator.should == @user.id.to_s
      end

      it "should store that assets were created using Excel import", versioning: true do
        post :import, "spreadsheet-file" => @file
        Asset.all.first.versions.first.metadata.should == "via Excel spreadsheet #{controller.view_context.content_tag(:strong, @file.original_filename)}"
      end

      describe "successfully" do

        before do
          Asset.should_receive(:import).with(an_instance_of(Rack::Test::UploadedFile)).once.and_return(true)
        end

        it "should redirect to root page" do
          post :import, "spreadsheet-file" => @file
          flash[:success].should_not be_nil
          response.should redirect_to root_path
        end

        it "should import xls data" do
          post :import, "spreadsheet-file" => @file
        end
      end

      describe "unsuccessfully" do

        before do
          Asset.should_receive(:import).with(an_instance_of(Rack::Test::UploadedFile)).once.and_return(["some error"])
        end

        it "should return client error" do
          post :import, "spreadsheet-file" => @file
          flash[:error].should_not be_nil
          response.should redirect_to root_path
        end
      end
    end

    describe "anonimous user" do

      it "should not be allowed" do
        post :import
        response.should redirect_to signin_path
      end
    end
  end
end
