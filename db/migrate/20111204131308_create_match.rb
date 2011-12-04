class CreateMatch < ActiveRecord::Migration
  def self.up
    create_table :match do |t|
      t.primary_key :id
      t.datetime    :occurs
      t.string      :location      
      t.integer     :required_players
      t.integer     :kind
      t.text        :comment
      t.references  :organizedby

      t.timestamps
    end
    
    # Manual add
    execute 'ALTER TABLE match ADD CONSTRAINT fk_match_player FOREIGN KEY (organizedby_id) REFERENCES player(id)'
    # add index
    add_index :match, :organizedby_id
 
  end

  def self.down
    drop_table :match
  end
end
