class Field < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  def self.get_by_player(player_id)
    ## Fixme: see http://guides.rubyonrails.org/v2.3.11/active_record_querying.html#conditions
    find(:first, :conditions => "field.player_id  = '#{player_id}'")
  end
  def self.get_by_player_and_match(player_id, match_id)
    ## Fixme: see http://guides.rubyonrails.org/v2.3.11/active_record_querying.html#conditions
    find(:first, :conditions => "field.player_id = '#{player_id}' AND field.match_id = '#{match_id}'")
  end 
end
