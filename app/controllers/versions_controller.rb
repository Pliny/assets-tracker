class VersionsController < ApplicationController

  before_action :authenticate
  before_action :set_page

  def index
    @versions = PaperTrail::Version.order("created_at DESC").page @page
  end

  private

  def set_page
    @page = params[:page] || 1
  end
end
