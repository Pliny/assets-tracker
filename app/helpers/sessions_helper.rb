module SessionsHelper

  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  def current_user?(user)
    user == current_user
  end

  def require_login
    head :unauthorized unless signed_in?
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    redirect_to signin_path, notice: "Please sign in to access this page."
  end

  def sign_out
    current_user = nil
    cookies.delete(:remember_token)
  end
end
