class AddScenarioEmail < ActiveRecord::Migration
  def change
    add_column :scenarios, :guest_email, :string
  end
end
