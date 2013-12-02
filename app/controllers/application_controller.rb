class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def signed_in?
    # No authentication yet.. so never signed in
    false
  end

  def require_login
    if signed_in?
      true
    else
      render :nothing => true, :status => 404
    end
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    redirect_to signin_path, notice: "Please sign in to access this page."
  end
end
