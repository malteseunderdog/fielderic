# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # render new.erb.html
  def new
  end

  def create    
    session[:email] = params[:email]    
    player = Player.get_player(params[:email])
    if (!player.nil?)
      password = player.password
      needs_password = (!password.nil? && !password.empty?)
      is_password_provided = (!params[:password].nil? && !params[:password].empty?)
      if (needs_password && !is_password_provided)
        # User account has a password set but no password was given at login
        session[:needs_password] = true
        redirect_to "/"
      else
        player = Player.get_player_with_password(params[:email], params[:password])
        if player
          # Protects against session fixation attacks, causes request forgery
          # protection if user resubmits an earlier form using back
          # button. Uncomment if you understand the tradeoffs.
          # reset_session
          session[:logged_in_player] = player
          new_cookie_flag = (params[:remember_me] == "1")
          redirect_to "/"
          flash[:notice] = "Logged in successfully"
        else
          # Incorrect email/password pair
          fail_login
        end
      end
    else
      # Email not found
      fail_login  
    end   
  end
  
  def fail_login
    note_failed_signin
    @email    = params[:email]
    @remember_me = params[:remember_me]
    session[:needs_password] = false
    redirect_to "/"
  end

  def destroy
    session[:logged_in_player] = nil
    session[:needs_password] = false
    flash[:notice] = "You have been logged out."
    redirect_to "/"
  end

protected

  # Track failed login attempts
  def note_failed_signin
    flash[:error] = "Couldn't log you in with '#{params[:email]}'"
    logger.warn "Failed login for '#{params[:email]}' from #{request.remote_ip} at #{Time.now.utc}"
  end
end
