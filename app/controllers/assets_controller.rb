class AssetsController < ApplicationController

  before_action :authenticate
  before_action :set_page

  def index
    @assets = Asset.order("updated_at DESC").page @page
  end

  def show
    @asset = Asset.find_by_id(params[:id])
    @showing = params[:action]
  end

  def edit
    @asset = Asset.find_by_id(params[:id])
    head :not_found if @asset.nil?
  end

  def update
    @asset = Asset.find_by_id(params[:id])
    return head :not_found if @asset.nil?

    @asset.update(allowable_asset_params)
    @asset.user = User.find_by_full_name(params[:asset][:user][:full_name].titleize) if params[:asset][:user]
    @asset.hardware_version = HardwareVersion.find_by(params[:asset][:hardware_version]) if params[:asset][:hardware_version]

    if @asset.save
      redirect_to asset_path(@asset)
    else
      if @asset.user.nil?
        @asset.user = User.new(:full_name => params[:asset][:user][:full_name])
        @asset.user.errors[:full_name] = "User doesn't exist"
      end

      if @asset.hardware_version.nil?
        @asset.hardware_version = HardwareVersion.new(allowable_hardware_version_params)
        @asset.hardware_version.errors[:name] = ""
        @asset.hardware_version.errors[:project] = ""
      end
      render :edit
    end
  end

  private

  def set_page
    @page = params[:page] || 1
  end

  def allowable_asset_params
    params.require(:asset).permit(:serial_no, :user_id, :mac_address, :notes, :in_house, :ipv4_address, :hardware_version_id)
  end

  def allowable_hardware_version_params
    params.require(:asset).require(:hardware_version).permit(:name, :project)
  end
end
