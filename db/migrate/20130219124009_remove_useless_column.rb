class RemoveUselessColumn < ActiveRecord::Migration
  def up
    remove_column :scenarios, :guest_email
  end

  def down
    add_column :scenarios, :guest_email, :string
  end
end
