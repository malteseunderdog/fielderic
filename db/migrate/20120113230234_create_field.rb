class CreateField < ActiveRecord::Migration
  def self.up
    create_table :field do |t|
      t.primary_key :id
      t.references :player
      t.references :match
      t.boolean :organiser
      t.boolean :active, :default => TRUE
      t.datetime :joined
      
      t.timestamps
    end
  end

  def self.down
    drop_table :field
  end
end
