class HomeController < ApplicationController
  
   skip_before_filter :require_login, :only => [:index ]
    
  def index
    # get the matches which have require some players
    # also limit the results to 7 because this is main page material...
    # why 7 ? ...  
    @matches = Match.future_games_with_required_players(7)
  end
  
  def sign_out
    session[:player]=nil
  end
end
