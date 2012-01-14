class AddRequiredPlayersNonNegativeConstraint < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE match ADD CONSTRAINT check_required_nonnegative CHECK (required >= 0)"
  end

  def self.down
    execute "ALTER TABLE match DROP CONSTRAINT check_required_nonnegative"
  end
end
