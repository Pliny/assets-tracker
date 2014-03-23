class VersionsController < ApplicationController

  before_action :authenticate

  def index
    @versions = PaperTrail::Version.order("created_at DESC")
  end
end
