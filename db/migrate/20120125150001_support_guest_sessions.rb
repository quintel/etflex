class SupportGuestSessions < ActiveRecord::Migration
  def up
    add_column    :scenarios, :guest_uid, :string, limit: 36
    change_column :scenarios, :user_id,   :integer, null: true
  end

  def down
    remove_column :scenarios, :guest_uid
    change_column :scenarios, :user_id,   :integer, null: false
  end
end
