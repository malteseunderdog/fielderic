class ApplicationController < ActionController::Base
  include Facebooker2::Rails::Controller
  protect_from_forgery

  before_filter :ensure_authenticated
  def ensure_authenticated
    if current_facebook_user.nil?
      #redirect_to url_for(:controller=>"home")
      else
      player = Player.get_player_with_facebook_id(current_facebook_user.id)
      current_facebook_user.fetch
      if player == nil
        Player.new_facebook_player(current_facebook_user)
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
end
