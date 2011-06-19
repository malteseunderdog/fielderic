class CreateMatches < ActiveRecord::Migration
  def self.up
    create_table :matches do |t|
      t.datetime :occurs
      t.string :location
      t.int :type
      t.int :required
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :matches
  end
end
