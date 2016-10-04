class AddBeagleboneIdToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :beaglebone_id, :integer, after: :session_id
  end
end
