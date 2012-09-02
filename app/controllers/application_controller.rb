class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery
  
  before_filter :ensure_authenticated
  before_filter :require_login
  
  def require_login
    unless !session[:logged_in_player].nil? # why not use if ?!
      flash[:login_required] = "You must be logged in to access this section"
      redirect_to :back
    end
  end
  
  
  def ensure_authenticated
    # TODO: This method is used so that if a user logs out from the FB page, the session player doesn't stay fixed forever.
    # The problem with this is that the user needs to make 2 page calls, for example 2 page reloads, until the session is nulled.
    #This is most certainly due to the Rails cookies. Maybe we need to find a more effective solution, but at least this works somewhat.
    if (cookies["#{Facebooker2.cookie_prefix + Facebooker2.app_id.to_s}"].nil? && !session[:logged_in_player].nil? && !session[:logged_in_player].fb_user_id.nil?)
      session[:logged_in_player] = nil
    end
    
    if session[:logged_in_player].nil?
      fb_user = current_facebook_user
      if !fb_user.nil?
        player = Player.get_player_with_facebook_id(fb_user.id)
        fb_user.fetch
        if player == nil
          player = Player.new_facebook_player(fb_user)
        end
        session[:logged_in_player] = player
      end
    end
  end

  def current_facebook_user
    begin
      if (Facebooker2.oauth2)
        oauth2_fetch_client_and_user
      else
        fetch_client_and_user
      end
      @_current_facebook_user
    rescue Exception=>e
      # Catch exceptions if user logs out from Facebook from another application
      # while logged in on FE using Facebook.
      # User is simply signed out of FE - no need to do any handling here.
    end
  end
  
  def current_player
    @current_player ||= Player.find(session[:player_id]) if session[:player_id]
  end
end
