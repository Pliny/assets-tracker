class SpreadsheetsController < ApplicationController

  before_action :authenticate

  def index
    @tool_active = true
  end

  def import
    result = Asset.import(params['spreadsheet-file'])
    if result == true
      flash[:success] = "Successfully imported spreadsheet!"
    else
      flash[:error] = "There were errors importing some rows: <strong>#{result.join(", ")}</strong>. All other rows have been successfully imported.".html_safe
    end
    redirect_to root_path
  end

  def info_for_paper_trail
    { :metadata => "via Excel spreadsheet #{view_context.content_tag(:strong, params['spreadsheet-file'].original_filename)}" }
  end

  private

  def paper_trail_enabled_for_controller
    PaperTrail.enabled? && action_name.to_sym == :import
  end
end
