class SessionsController < ApplicationController

  def new
  end

  def destroy
    sign_out
    redirect_to signin_path
  end
end
