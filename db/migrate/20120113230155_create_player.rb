class CreatePlayer < ActiveRecord::Migration
  def self.up
    create_table :player do |t|
      t.primary_key :id
      t.string :nickname, :limit => 40
      t.string :name, :limit => 100
      t.string :email, :limit => 100
      t.string :mobile, :limit => 20
      t.string :password, :limit => 40
      t.string :salt, :limit => 40
      t.string :location
      t.datetime :registration
      t.string :remember_token, :limit => 40
      t.datetime :remember_token_expires_at

      t.timestamps
    end
    add_index :player, :nickname, :unique => true
  end

  def self.down
    drop_table :player
  end
end
