require 'spec_helper'

describe "Dynamic Flows", js: true do
  self.use_transactional_fixtures = false

  after do
    # Do not delete data in schema table
    ActiveRecord::Base.connection.tables.each do |table|
      model_name = table.camelize.singularize
      if model_name != "SchemaMigration" && model_name != "Version"
        model_name.constantize.delete_all
      end
    end
  end

  describe "spreadsheet importing" do

    # Wait for page to fully load
    before do
      integration_login
      visit spreadsheets_path
      find(".content")
    end

    describe "successfully" do

      it "should show success indicator" do
        attach_file "File Input", "#{Rails.root}/spec/fixtures/files/simple_test.xlsx"
        find("#spreadsheet-submit:not([disabled])")
        click_button "Import"
        current_path.should == root_path
        find(".alert-dismissable.alert-success")
      end
    end

    describe "unsuccessfully" do

      before do
        @admin = ENV['ASSETS_ADMIN']
        ENV['ASSETS_ADMIN'] = nil
      end

      after  { ENV['ASSETS_ADMIN'] = @admin}

      it "should show fail indicator" do
        attach_file "File Input", "#{Rails.root}/spec/fixtures/files/simple_test_no_user.xlsx"
        find("#spreadsheet-submit:not([disabled])")
        click_button "Import"
        current_path.should == root_path
        find(".alert-dismissable.alert-danger")
      end
    end
  end
end

