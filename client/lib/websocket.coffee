class exports.Websocket
  constructor: ->
    @ws = new WebSocket('ws://localhost:8080')
    @ws.onmessage = @onMessage

  onMessage: (ev) =>
    data = JSON.parse(ev.data)
    @calculateResults(data.pieces)

  calculateResults: (pieces) ->
    pieces = _(pieces).countBy (piece) -> piece

    bioGas        = pieces["bio_gas"]           || 0
    coalPlants    = pieces["coal_plant"]        || 0
    electricCars  = pieces["electric_car"]      || 0
    fuelCells     = pieces["fuel_cell"]         || 0
    gasPlants     = pieces["gas_plant"]         || 0
    heatPumps     = pieces["heat_pump"]         || 0
    insulation    = pieces["insulation"]        || 0
    ledLights     = pieces["led_light"]         || 0
    nuclearPlants = pieces["nuclear_plant"]     || 0
    pvPanels      = pieces["pv_panel"]          || 0
    waterHeaters  = pieces["thermal_collector"] || 0
    windTurbines  = pieces["wind_turbine"]      || 0

    results = {}

    results.households_insulation_level_old_houses = 0.5 + (insulation * 0.5)
    results.households_lighting_led_electricity_share = (100/5) * ledLights
    results.transport_car_using_electricity_share = (100/5) * electricCars
    results.households_water_heater_fuel_cell_chp_network_gas_share = fuelCells * 10
    results.households_space_heater_heatpump_ground_water_electricity_share = heatPumps * 20
    results.households_water_heater_solar_thermal_share = (100/5) * waterHeaters

    results.number_of_energy_power_ultra_supercritical_coal = coalPlants * 2
    results.number_of_energy_power_combined_cycle_network_gas = gasPlants * 2
    results.number_of_energy_power_nuclear_gen3_uranium_oxide = nuclearPlants
    results.number_of_energy_power_wind_turbine_offshore = 500 * windTurbines
    results.households_solar_pv_solar_radiation_market_penetration = (100/5) * pvPanels
    results.green_gas_total_share = 2 * bioGas

    for key, value of results
      slider = $("##{ key }").data 'quinn'
      slider.setValue(value, true, false)

