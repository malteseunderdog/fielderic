class AddUsersFb < ActiveRecord::Migration
  def self.up
    add_column :player, :fb_user_id, :bigint
    add_column :player, :email_hash, :string
    #if mysql
    #execute("alter table users modify fb_user_id bigint")
  end
  def self.down
    remove_column :player, :fb_user_id
    remove_column :player, :email_hash
  end
end
