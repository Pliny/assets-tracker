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
end
