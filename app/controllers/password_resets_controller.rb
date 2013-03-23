class PasswordResetsController < ApplicationController
  
  skip_before_filter :require_login
  
  def create
    player = Player.get_player(params[:email])
    if player
      player.send_password_reset
      flash[:main_page_message] = "Email sent with password reset instructions."
      redirect_to "/"
    else
      flash[:error] = "Unknown email address <" + params[:email] + ">."
      render :new
    end
  end
  
  def edit
    @player = Player.find_by_password_reset_token!(params[:id])
  end

  def update
    @player = Player.find_by_password_reset_token!(params[:id])
    
    if @player.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    else
      
      @player.password = Digest::SHA2.hexdigest(@player.id.to_s() + params[:player][:password])
      
      if @player.save
        flash[:main_page_message] = "Password has been reset!"
        redirect_to "/"
      else
        render :edit
      end
    end
    
  end
  
end