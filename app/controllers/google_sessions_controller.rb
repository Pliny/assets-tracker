class GoogleSessionsController < ApplicationController

  def login
    auth = request.env['omniauth.auth']

    if auth.info['email'].split('@')[1] == ENV['EMAIL_SERVER']

      user = User.find_by_email(auth.info['email']) ||
        User.find_by_full_name("#{auth.info['first_name'].strip.titleize} #{auth.info['last_name'].strip.titleize}") ||
        User.new

      user.google_id    = auth['uid']
      user.email        = auth.info['email']
      user.first_name   = auth.info['first_name']
      user.last_name    = auth.info['last_name']
      user.google_image_url = auth.info['image']
      user.google_hd    = auth.extra.raw_info['hd']
      user.google_token = auth.credentials['token']

      user.save!

      sign_in user

      redirect_to  root_url || request.env['omniauth.origin']

    else
      flash[:error] = "Sorry, you must be part of this group to create an account"
      redirect_to signin_url
    end

  end

  def error
    flash[:error] =  "Sorry, something went wrong with the login."
    redirect_to request.env['omniauth.origin'] || signin_url
  end
end
