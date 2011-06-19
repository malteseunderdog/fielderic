class CreateMatch < ActiveRecord::Migration
  def self.up
    create_table :match do |t|
      t.primary_key :id
      t.datetime :occurs
      t.string :location
      t.int :kind
      t.int :required
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :match
  end
end
