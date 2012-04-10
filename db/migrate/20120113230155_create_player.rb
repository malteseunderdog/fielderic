class CreatePlayer < ActiveRecord::Migration
  def self.up
    create_table :player do |t|
      t.primary_key :id
      t.string :nickname
      t.string :name
      t.string :email
      t.string :mobile
      t.string :password
      t.string :location
      t.datetime :registration

      t.timestamps
    end
  end

  def self.down
    drop_table :player
  end
end
