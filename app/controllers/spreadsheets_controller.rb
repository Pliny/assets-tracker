class SpreadsheetsController < ApplicationController

  def index
    @tool_active = true
  end

  def import
    if Asset.import(params['spreadsheet-file']) == true
      redirect_to root_path
    else
      head :bad_request
    end
  end
end
