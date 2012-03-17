class Field < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  
  def self.get_by_player(player_id)
    find(:all, :conditions => ["field.player_id  = ?", player_id])
  end
  
  def self.get_by_player_and_match(player_id, match_id)
    find(:first, :conditions => ["field.player_id = ? AND field.match_id = ?", player_id, match_id])
  end
   
end
