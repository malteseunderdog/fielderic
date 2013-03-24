class UserMailer < ActionMailer::Base
  default from: "seven@fielderic.com"
  
  def password_reset(player)
    @player = player
    mail :to => player.email, :subject => "Password Reset"
  end
  
  def notify_player_about_match(player, match)
    @player = player
    @match = match
    mail :to => player.email, :subject => "[fielderic] Start warming up, football match at " + match.kickoff.to_default_s()
  end
  
  def contact_us
    mail :to => "seven@fielderic.com", :subject => "Message from fielderic.com"
  end
  
end
