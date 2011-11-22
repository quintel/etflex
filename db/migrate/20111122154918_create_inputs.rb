class CreateInputs < ActiveRecord::Migration
  INPUTS = [
    { key: 'households_lighting_low_energy_light_bulb_share',                          start: 5, remote_id:  43 },
    { key: 'transport_cars_electric_share',                                                      remote_id: 146 },
    { key: 'households_insulation_level_old_houses',          min: 1, max:         3,  start: 1, remote_id: 336 },
    { key: 'households_hot_water_solar_water_heater_share',           max:        50,            remote_id: 348 },
    { key: 'households_behavior_standby_killer_turn_off_appliances',                             remote_id: 366 },
    { key: 'households_heating_heat_pump_ground_share',                                          remote_id: 338 },
    { key: 'number_of_coal_conventional',                             max:       300,            remote_id: 315 },
    { key: 'number_of_gas_conventional',                              max:       300,            remote_id: 256 },
    { key: 'number_of_nuclear_3rd_gen',                               max:       300,            remote_id: 259 },
    { key: 'number_of_wind_onshore_land',                             max:       300,            remote_id: 263 },
    { key: 'number_of_solar_pv_roofs_fixed',                          max: 100000000,            remote_id: 313 },
    { key: 'policy_area_biomass',                                     max:         0,            remote_id: 196 }
  ]

  def up
    create_table :inputs do |t|
      t.string  :key,                     null: false
      t.float   :step,      default: 1,   null: false
      t.float   :min,       default: 0,   null: false
      t.float   :max,       default: 100, null: false
      t.float   :start,     default: 0,   null: false
      t.string  :unit
      t.integer :remote_id,               null: false
    end

    INPUTS.each { |data| Input.create(data) }

    unless Input.count == INPUTS.length
      down

      raise "The inputs weren't added; has the Input model validation "\
            "been changed?"
    end
  end

  def down
    drop_table :inputs
  end
end
