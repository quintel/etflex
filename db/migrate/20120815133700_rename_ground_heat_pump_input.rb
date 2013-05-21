class RenameGroundHeatPumpInput < ActiveRecord::Migration
  def up
    input = Input.where(key: 'households_space_heater_heatpump_ground_water_electricity_share').first!
    input.key = 'households_space_heater_heatpump_ground_water_electricity'
    input.save!
  end

  def down
    input = Input.where(key: 'households_space_heater_heatpump_ground_water_electricity').first!
    input.key = 'households_space_heater_heatpump_ground_water_electricity_share'
    input.save!
  end
end
