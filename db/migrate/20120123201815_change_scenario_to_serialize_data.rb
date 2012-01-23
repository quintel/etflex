class ChangeScenarioToSerializeData < ActiveRecord::Migration
  def change
    remove_column :scenarios, :score
    remove_column :scenarios, :costs
    remove_column :scenarios, :co2
    remove_column :scenarios, :renewability

    rename_column :scenarios, :user_values, :input_values

    add_column    :scenarios, :query_results, :text
  end
end
