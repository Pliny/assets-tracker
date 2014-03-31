class DevicesController < ApplicationController

  before_action :authenticate
  before_action :set_page

  def index
    @devices = Device.order("updated_at DESC").page @page
  end

  def show
    @device = Device.find_by_id(params[:id])
    @showing = params[:action]
  end

  def edit
    @device = Device.find_by_id(params[:id])
    head :not_found if @device.nil?
  end

  def update
    @device = Device.find_by_id(params[:id])
    return head :not_found if @device.nil?

    @device.update(allowable_asset_params)
    @device.user = User.find_by_full_name(params[:device][:user][:full_name].titleize) if params[:device][:user]
    @device.hardware_version = HardwareVersion.find_by(params[:device][:hardware_version]) if params[:device][:hardware_version]

    if @device.save
      flash[:success] = "Sucessfully updated #{@device.serial_no}"
      redirect_to device_path(@device)
    else
      if @device.user.nil?
        @device.user = User.new(:full_name => params[:device][:user][:full_name])
        @device.user.errors[:full_name] = "User doesn't exist"
      end

      if @device.hardware_version.nil?
        @device.hardware_version = HardwareVersion.new(allowable_hardware_version_params)
        @device.hardware_version.errors[:name] = ""
        @device.hardware_version.errors[:project] = ""
      end
      render :edit
    end
  end

  def new
    @device = Device.new
    @device.user = User.new
    @new = params[:action]
  end

  def create
    user = User.find_by_full_name(params[:device][:user][:full_name].titleize) if params[:device][:user]
    @device = Device.new(allowable_asset_params)
    @device.user = user
    @device.save
    if @device.errors.present?
      if @device.user.nil?
        @device.user = User.new(:full_name => params[:device][:user][:full_name])
        @device.user.errors[:full_name] = "User doesn't exist"
      end
      @new = params[:action]
      render 'new'
    else
      flash[:success] = "Sucessfully created #{@device.serial_no}"
      redirect_to device_path(@device)
    end
  end

  private

  def set_page
    @page = params[:page] || 1
  end

  def allowable_asset_params
    params.require(:device).permit(:serial_no, :user_id, :mac_address, :notes, :in_house, :ipv4_address, :hardware_version_id)
  end

  def allowable_hardware_version_params
    params.require(:device).require(:hardware_version).permit(:name, :project)
  end
end
