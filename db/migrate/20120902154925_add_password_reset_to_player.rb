class AddPasswordResetToPlayer < ActiveRecord::Migration
  def change
    add_column :player, :password_reset_token, :string
    add_column :player, :password_reset_sent_at, :datetime
  end
end
