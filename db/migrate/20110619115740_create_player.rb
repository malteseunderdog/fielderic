class CreatePlayer < ActiveRecord::Migration
  def self.up
    create_table :player do |t|
      t.string :nickname
      t.sting :email
      t.string :email
      t.string :mobile
      t.text :password
      t.string :coordinates
      t.string :location
      t.datetime :registration

      t.timestamps
    end
  end

  def self.down
    drop_table :player
  end
end
