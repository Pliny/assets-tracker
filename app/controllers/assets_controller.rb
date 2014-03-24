class AssetsController < ApplicationController

  before_action :authenticate
  before_action :set_page

  def index
    @assets = Asset.order("updated_at DESC").page @page
  end

  def edit
    @asset = Asset.find_by_id(params[:id])
    head :not_found if @asset.nil?
  end

  def update
    asset = Asset.find_by_id(params[:id])
    return head :not_found if asset.nil?

    asset.update(allowable_params)
    asset.user = User.find_by_full_name(params[:asset][:user][:full_name].titleize) if params[:asset][:user]
    asset.hardware_version = HardwareVersion.find_by(params[:asset][:hardware_version]) if params[:asset][:hardware_version]

    if asset.save
      redirect_to assets_path
    else
      redirect_to edit_asset_path(params[:id])
    end
  end

  private

  def set_page
    @page = params[:page] || 1
  end

  def allowable_params
    params.require(:asset).permit(:serial_no, :user_id, :mac_address, :notes, :in_house, :ipv4_address, :hardware_version_id)
  end
end
