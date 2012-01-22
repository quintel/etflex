class AddMoreInformationToScenarios < ActiveRecord::Migration
  def change
    add_column :scenarios, :title,         :string
    add_column :scenarios, :score,         :float
    add_column :scenarios, :costs,         :float
    add_column :scenarios, :co2,           :float
    add_column :scenarios, :renewability,  :float
    add_column :scenarios, :user_values,   :text
    add_column :scenarios, :updated_at,    :datetime
  end
end
