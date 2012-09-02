class UserMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def password_reset(player)
    @player = player
    mail :to => player.email, :subject => "Password Reset"
  end
  
end
