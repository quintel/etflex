class AddCountryAndEndYearToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :end_year, :integer, null: false, default: 2050
    add_column :scenarios, :country,  :string, limit: 2, null: false, default: 'nl'
  end
end
