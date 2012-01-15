class HomeController < ApplicationController  
  def index
    @match = Match.future
    
    if params[:password].nil?
      unless params[:nickname].nil?
        @player = Player.get_player(params[:nickname])
        unless @player.nil?
          if not @player.password.nil? and @player.password==""
            params[:signed_in] = true
          end          
          respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @player }
          end
        else
          @player = "Nickname error"
          return @player 
        end  
      end
    else
      unless params[:nickname].nil?
        @player = Player.get_player_with_password(params[:nickname], params[:password])
        unless @player.nil?
          params[:signed_in] = true
          respond_to do |format|
            format.html # show.html.erb
            format.xml  { render :xml => @player }
          end
        else
          @player = params[:nickname]
          return @player 
        end  
      end
    end
  end
  
  def sign_out
    session[:player]=nil
  end
end
