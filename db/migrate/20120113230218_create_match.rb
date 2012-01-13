class CreateMatch < ActiveRecord::Migration
  def self.up
    create_table :match do |t|
      t.primary_key :id
      t.datetime :created
      t.datetime :kickoff
      t.string :location
      t.string :variety
      t.integer :required
      t.string :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :match
  end
end
