class DefaultScenarioYearTo2030 < ActiveRecord::Migration
  def up
    change_column :scenarios, :end_year, :integer, default: 2030, null: false
  end

  def down
    change_column :scenarios, :end_year, :integer, default: 2050, null: false
  end
end
