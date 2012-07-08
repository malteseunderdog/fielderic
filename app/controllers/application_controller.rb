class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery
  
  before_filter :ensure_authenticated
  def ensure_authenticated
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
