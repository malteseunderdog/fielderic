# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController

  skip_before_filter :require_login, :only => [ :login ]

  # method called upon clicking Play button
  def login

    email = params[:email].downcase
    password = params[:password]
    player = Player.get_player(email)

    if !password.nil? 
      password = Digest::SHA2.hexdigest(player.id.to_s() + password)
    end      
        
    if (!player.nil?)
      # let us check if we should show a password field or not
      @needs_password_field = !player.password.blank?

      if @needs_password_field
        # user needs a password -- but we might have already set this and we want
        # to check the password is correct
        if password != player.password and !password.blank? 
          flash.now[:error] = "Incorrect username and password combination"
        elsif !password.nil? and password.empty?
          flash.now[:error] = "Empty password"
        elsif password == player.password
          session[:logged_in_player] = player
        end
                
      else
        # no need for a password...
        session[:logged_in_player] = player
      end 
      
    else
      # use flesh.now as I want this only available for current request
      flash.now[:error] = "Unknown user email"
    end
        
    respond_to do |format|
      format.js { render :layout=>false }     
    end
  end

  # logout 
  def logout
    session[:logged_in_player] = nil
    cookies.delete(:refreshed)
    redirect_to "/"
  end

    
end
