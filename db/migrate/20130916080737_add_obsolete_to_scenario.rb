class AddObsoleteToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :obsolete, :boolean, default: false
  end
end
