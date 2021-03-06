class Field < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  
  def self.get_by_player(player_id)
    find(:all, 
         :conditions => ["field.player_id  = ? AND match.kickoff > ?", player_id, DateTime.now], 
         :joins => :match,            # you need this as you want to order by on a match attribute
         :order => "match.kickoff")
  end
  
  def self.get_organised_by_player(player_id)
    find(:all, 
         :conditions => ["field.player_id  = ? AND match.kickoff > ? AND field.organiser = true", player_id, DateTime.now], 
         :joins => :match,            # you need this as you want to order by on a match attribute
         :order => "match.kickoff")
  end

  def self.get_by_match(match_id)
    find(:all, 
         :conditions => ["field.match_id  = ? AND field.active = 't'", match_id], 
         :order => "field.joined")
  end
  
  def self.get_by_player_and_match(player_id, match_id)
    find(:first, :conditions => ["field.player_id = ? AND field.match_id = ? AND field.active = 't'", player_id, match_id])
  end

  def self.get_notifaction_fields()
    find(:all, 
         :joins => [:match, :player],
         :readonly => false , 
         :conditions => ["field.active = 't' AND field.notified = 'f' AND match.kickoff >= ? AND match.kickoff < ?", DateTime.now, DateTime.now + 12.hours ])
  end
   
end
