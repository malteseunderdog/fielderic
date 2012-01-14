class Field < ActiveRecord::Base
  belongs_to :player
  belongs_to :match
  def self.get_by_player(player_id)
    find(:first, :conditions => "field.player_id  = '#{player_id}'")
  end
end
