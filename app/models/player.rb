class Player < ActiveRecord::Base
  has_many :fields
  has_many :matches, :through => :fields
        
  def self.get_player(email)
    find(:first, :conditions => "email = '#{email}'")
  end
  
  def self.get_player_by_id(id)
    find(:first, :conditions => "id = '#{id}'")
  end
  
  def self.get_player_by_nickname(nickname)
    find(:first, :conditions => "nickname = '#{nickname}'")
  end
  
  def self.get_player_by_mobile(mobile)
    find(:first, :conditions => "mobile = '#{mobile}'")
  end
  
  def self.get_player_with_password(email, password)
    player = get_player(email)
    if !player.nil?
      password = Digest::SHA2.hexdigest(player.id.to_s() + password)      
    end    
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
    player = get_player(email)
    if !player.nil?
      password = Digest::SHA2.hexdigest(player.id.to_s() + password)      
    end    
    where("email = ? AND password = ?", email, password).first
  end  
   
  def self.get_joined_players(match_id)
    find(:all,
      :conditions => ["field.match_id = ? AND field.organiser = 'f' AND field.active = 't'", match_id],
      :joins => :fields,
      :order => "field.id") # order by join order
  end
  
  def self.get_organiser(match_id)
    find(:first,
      :conditions => ["field.match_id = ? AND field.organiser = 't'", match_id],
      :joins => :fields)
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while Player.exists?(column => self[column])
  end
  
end