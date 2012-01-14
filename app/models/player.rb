class Player < ActiveRecord::Base
  def self.get_player(nickname)
    find(:first, :conditions => "nickname = '#{nickname}'")
  end
  def self.get_player_with_password(nickname, password)
    find(:first, :conditions => "nickname = '#{nickname}' AND password = '#{password}'")
  end
end