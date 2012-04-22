class Player < ActiveRecord::Base
  has_many :fields
  has_many :matches, :through => :fields
  
  def self.get_player(nickname)
    find(:first, :conditions => "nickname = '#{nickname}'")
  end
  
  def self.get_player_with_password(nickname, password)
    find(:first, :conditions => "nickname = '#{nickname}' AND password = '#{password}'")
  end
  
  def self.get_player_with_facebook_id(facebook_id)
    find(:first, :conditions => "fb_user_id = '#{facebook_id}'")
  end
  
  def self.new_facebook_player(current_facebook_user)
    username = current_facebook_user.username
    if username == nil
      username = current_facebook_user.first_name
    end
    @fb_player = Player.new(:nickname=>username, :name=>current_facebook_user.name, :email=>current_facebook_user.email, :fb_user_id=>current_facebook_user.id)
    @fb_player.save
  end
  
end