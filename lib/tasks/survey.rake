namespace :survey do
  desc 'Dumps survey scenarios into a CSV'
  task dump: :environment do
    require 'csv'

    # Start DB connection.
    Scenario.connection

    columns = {
      key:          ->(s) { s.guest_uid },
      scenario_id:  ->(s) { s.session_id },
      started_at:   ->(s) { s.created_at },
      finished_at:  ->(s) { s.updated_at },
      duration:     ->(s) { s.updated_at - s.created_at }
    }

    fetch_input = ->(s, key) {
      (s.input_values || {})[key]
    }

    fetch_query = ->(s, key) {
      results = s.query_results || {}
      query   = results[key] || {}

      query['future']
    }

    input_keys = %w(
      households_insulation_level_old_houses
      households_lighting_led_electricity_share
      transport_car_using_electricity_share
      households_water_heater_fuel_cell_chp_network_gas_share
      households_space_heater_heatpump_ground_water_electricity_share
      households_water_heater_solar_thermal_share
      number_of_energy_power_ultra_supercritical_coal
      number_of_energy_power_combined_cycle_network_gas
      number_of_energy_power_nuclear_gen3_uranium_oxide
      number_of_energy_power_wind_turbine_offshore
      households_solar_pv_solar_radiation_market_penetration
      green_gas_total_share
    )

    query_keys = %w(
      total_co2_emissions
      number_of_electric_cars
      total_electricity_produced
      final_demand_of_electricity
      electricity_produced_from_uranium
      electricity_produced_from_solar
      security_of_supply_reliability
      share_of_heat_pump_in_heat_produced_in_households
      share_of_heat_demand_saved_by_extra_insulation_in_existing_households
      share_of_solar_boiler_in_hot_water_produced_in_households
      share_of_total_costs_assigned_to_wind
      etflex_score
    )

    headers = (
      columns.keys +
      input_keys.map { |v| "input.#{v}" } +
      query_keys.map { |v| "result.#{v}" }
    )

    # Duplicate check
    # ---------------

    duplicate_scenarios = Scenario.where(
      guest_uid: Scenario.select(:guest_uid)
        .group(:guest_uid).having('COUNT(*) > 1')
    ).order('updated_at DESC').group_by(&:guest_uid).values

    duplicates = duplicate_scenarios.map do |scenarios|
      # Find the most recent scenario whose score suggests the user changed
      # a slider.
      canonical = scenarios.detect do |scenario|
        ! (scenario.score.try(:floor) || 0).between?(475, 478)
      end

      scenarios.map(&:id) - [(canonical || scenarios.first).id]
    end.flatten

    # Create the CSV
    # --------------

    csv = CSV.generate(headers: headers, write_headers: true) do |csv|
      Scenario.find_each do |scenario|
        next unless scenario.scene_id == 1 && scenario.guest_uid
        next if     duplicates.include?(scenario.id)

        static  = columns.values.map { |fetcher| fetcher.call(scenario) }
        inputs  = input_keys.map { |key| fetch_input.call(scenario, key) }
        queries = query_keys.map { |key| fetch_query.call(scenario, key) }

        csv << (static + inputs + queries)
      end
    end

    File.write('tmp/survey.csv', csv)
  end
end
