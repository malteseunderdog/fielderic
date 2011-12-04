class CreateField < ActiveRecord::Migration
  def self.up
    create_table :field do |t|
      t.primary_key :id
      t.datetime    :joined
      t.references  :player
      t.references  :match

      t.timestamps
    end
    
    ### MANUAL EDITS - Take care not to loose these upon regenerate
    
    #add a foreign key
    execute 'ALTER TABLE field ADD CONSTRAINT fk_field_player FOREIGN KEY (player_id) REFERENCES player(id)'
    execute 'ALTER TABLE field ADD CONSTRAINT fk_field_match FOREIGN KEY (match_id) REFERENCES match(id)'
    execute 'ALTER TABLE field ADD CONSTRAINT ck_unique_player_id_match_id UNIQUE (player_id, match_id)'
    
    execute 'ALTER TABLE field ALTER COLUMN joined SET DEFAULT now()'
 
    # add foreign key indices (best practice)
    add_index :field, :player_id
    add_index :field, :match_id
    
  end

  def self.down
    drop_table :field
  end
end
