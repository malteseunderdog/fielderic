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
end
