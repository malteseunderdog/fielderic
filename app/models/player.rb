class Player < ActiveRecord::Base
  has_many :fields
  has_many :matches, :through => :fields
        
  def self.get_player(email)
    find(:first, :conditions => "email = '#{email}'")
  end
  
  def self.get_player_by_id(id)
    find(:first, :conditions => "id = '#{id}'")
  end
  
  def self.get_player_with_password(email, password)
    find(:first, :conditions => "email = '#{email}' AND password = '#{password}'")
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
    @fb_player
  end
  
  def self.authenticate(email, password)
    where("email = ? AND password = ?", email, password).first
  end
  
  def self.get_joined_players(match_id)
    find(:all,
      :conditions => ["field.match_id = ? ", match_id],
      :joins => :fields,
      :order => "field.id") # order by join order
  end
  
  def self.get_organiser(match_id)
    find(:first,
      :conditions => ["field.match_id = ? AND field.organiser = 't'", match_id],
      :joins => :fields)
  end
  
end