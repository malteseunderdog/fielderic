class Match < ActiveRecord::Base
  has_many :fields
  has_many :players, :through => :fields
  
  validates_presence_of     :location
  validates_numericality_of :required, :only_integer => true, :greater_than_or_equal_to => 0
  
  
  # Gets only the #future# matches
  def self.future()
    # where kickoff past some date
    all(:conditions => ["kickoff > ?", DateTime.now], :order => 'kickoff')   
  end

  # Gets only the #future# matches for which players are required
  def self.future_games_with_required_players(limit)
    # where kickoff past some date (now) and we need some players for 
    # these matches
    all(:conditions => ["kickoff > ? and required > 0", DateTime.now],
        :limit => limit, 
        :order => 'kickoff')   
  end
  
end
