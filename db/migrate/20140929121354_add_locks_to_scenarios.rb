class AddLocksToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :locked, :boolean, default: false
  end
end
