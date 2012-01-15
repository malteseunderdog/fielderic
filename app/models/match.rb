class Match < ActiveRecord::Base
  validates_presence_of     :location
  validates_numericality_of :required, :only_integer => true, :greater_than_or_equal_to => 0
  
  
  # Gets only the #future# matches
  # When 
  def self.future()
    # where kickoff past some date
    all(:conditions => ["kickoff > ?", DateTime.now])   
  end
  
end
