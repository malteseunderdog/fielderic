class CreatePlayer < ActiveRecord::Migration
  def self.up
    create_table :player do |t|
      t.primary_key :id
      t.string      :name
      t.string      :nickname
      t.string      :email
      t.string      :mobile
      t.string      :password
      t.string      :coordinates
      t.string      :location
      t.datetime    :registration

      t.timestamps
    end
    
    execute 'ALTER TABLE player ALTER COLUMN registration SET DEFAULT now()'
  end

  def self.down
    drop_table :player
  end
end
