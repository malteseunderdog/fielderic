class AddNotifiedToField < ActiveRecord::Migration
  def change
    add_column :field, :notified, :boolean, default: false
  end
end
