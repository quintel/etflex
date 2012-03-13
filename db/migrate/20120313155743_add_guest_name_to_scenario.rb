class AddGuestNameToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :guest_name, :string, limit: 50
  end
end
