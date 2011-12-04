class HomeController < ApplicationController  
  def index
    if params[:password].nil?
      unless params[:nickname].nil?
        @player = Player.get_player(params[:nickname])
        unless @player.nil?
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
