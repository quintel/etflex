# ---
# total_co2_emissions: 123401383201.6039
# total_costs: 41367109271.60709
# renewability: 0.10007295070401988
# total_electricity_produced: 437019725179.4927
# final_demand_of_electricity: 423712863513.1742
# score: 835.2315075267891
# security_of_supply_blackout_risk: 0.04493125887509286
# number_of_electric_cars: 2712513.2475415566
# electricity_produced_from_uranium: 28788700397.977203
# electricity_produced_from_solar: 21964820866.553738
# electricity_produced_from_oil: 10483348522.854298
# share_of_heat_pump_in_heat_produced_in_households: 0.02
# share_of_heat_demand_saved_by_extra_insulation_in_existing_households: 0.5173144876325089
# share_of_solar_boiler_in_hot_water_produced_in_households: 0.42
# share_of_total_costs_assigned_to_wind: 0.013119177528895383


class AddOutputColumnsToScenarios < ActiveRecord::Migration
  def up
    add_column :scenarios, :total_co2_emissions,  :float
    add_column :scenarios, :total_costs,          :float
    add_column :scenarios, :renewability,         :float
    add_column :scenarios, :created_at,           :datetime

    unless column_exists? :scenarios, :score
      add_column :scenarios, :score,              :float
    end
  end

  def down
    remove_column :scenarios, :total_co2_emissions,  :float
    remove_column :scenarios, :total_costs,          :float
    remove_column :scenarios, :renewability,         :float
    remove_column :scenarios, :created_at,           :datetime
    remove_column :scenarios, :score,                :float
  end
end
