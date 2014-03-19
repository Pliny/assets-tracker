class VersionsController < ApplicationController

  before_action :authenticate

  def index
    @history = PaperTrail::Version.order("created_at DESC")
  end
end
