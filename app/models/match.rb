class Match < ActiveRecord::Base
  has_many :fields
  has_many :players, :through => :fields
  
  validates_presence_of     :location
  validates_numericality_of :required, :only_integer => true, :greater_than_or_equal_to => 0
  
  
  # Gets only the #future# matches
  def self.future()
    # where kickoff past some date
    all(:conditions => ["kickoff > ? AND active = 't'", DateTime.now], :order => 'kickoff')   
  end

  # Gets only the #future# matches for which players are required
  def self.future_games_with_required_players(limit)
    # where kickoff past some date (now) and we need some players for 
    # these matches
    all(:conditions => ["kickoff > ? and required > 0 AND active = 't'", DateTime.now],
        :limit => limit, 
        :order => 'kickoff')   
  end
  
  def self.my_future_matches(player_id)
    find(:all, 
      :conditions => ["match.kickoff > ? AND active = 't' AND field.player_id  = ? AND field.active = 't'", DateTime.now, player_id], 
      :joins => :fields,
      :order => "match.kickoff")
  end
  
  def self.my_past_matches(player_id)
    find(:all, 
      :conditions => ["match.kickoff < ? AND active = 't' AND field.player_id  = ? AND field.active = 't'", DateTime.now, player_id], 
      :joins => :fields,
      :order => "match.kickoff")
  end
  
  def self.my_organised_future_matches(player_id)
    find(:all, 
      :conditions => ["match.kickoff > ? AND active = 't' AND field.player_id  = ? AND field.organiser = 't'", DateTime.now, player_id], 
      :joins => :fields,
      :order => "match.kickoff")
  end
  
end
