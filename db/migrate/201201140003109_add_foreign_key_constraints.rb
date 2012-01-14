class AddForeignKeyConstraints < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE field ADD CONSTRAINT fk_player FOREIGN KEY (player_id) REFERENCES player(id)";
    execute "ALTER TABLE field ADD CONSTRAINT fk_match FOREIGN KEY (match_id) REFERENCES match(id)";
  end

  def self.down
    execute "ALTER TABLE field DROP CONSTRAINT fk_player"
    execute "ALTER TABLE field DROP CONSTRAINT fk_match"
  end
end
