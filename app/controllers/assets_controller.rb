class AssetsController < ApplicationController

  before_action :authenticate
  before_action :set_page

  def index
    @assets = Asset.order("updated_at DESC").page @page
  end

  private

  def set_page
    @page = params[:page] || 1
  end
end
