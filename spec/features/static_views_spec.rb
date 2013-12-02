require 'spec_helper'

describe "Static Views" do

  subject { page.body }

  describe "index" do

    before { visit root_path }

    it { should have_selector('.navbar-header a.navbar-brand')}

    it "should have the App name" do
      find('.navbar-header a.navbar-brand').should have_content("Asset Tracker")
    end

    # describe "and javascript enabled", js: true do
    #   self.use_transactional_fixtures = false
    #
    #   # Wait for page to fully load
    #   before { find(".admin-form") }

    #   after do
    #     # Do not delete data in schema table
    #     ActiveRecord::Base.connection.tables.each do |table|
    #       model_name = table.camelize.singularize
    #       if model_name != "SchemaMigration"
    #         model_name.constantize.delete_all
    #       end
    #     end
    #   end

    #   it "should work with capybara-webkit" do
    #     click_button "SKIP"
    #     find('.page+.page')
    #   end
    # end
  end
end

