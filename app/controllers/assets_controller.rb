class AssetsController < ApplicationController

  before_action :authenticate

  def index
    @assets = Asset.order("updated_at DESC")
  end
end
