# encoding: utf-8

class AddInformationToSceneInputs < ActiveRecord::Migration
  def up
    add_column :scene_inputs, :information_en, :text
    add_column :scene_inputs, :information_nl, :text

    # Add existing translations.
    Scene.all.each do |scene|
      scene.scene_inputs.each do |input|
        input.information_en = INPUT_TRANSLATIONS['en'][input.key.to_s].presence
        input.information_nl = INPUT_TRANSLATIONS['nl'][input.key.to_s].presence

        input.save!
      end
    end
  rescue StandardError => e
    down
    raise e
  end

  def down
    remove_column :scene_inputs, :information_en
    remove_column :scene_inputs, :information_nl
  rescue
  end
end

INPUT_TRANSLATIONS = YAML.load <<-YAMLDOC
---
en:
  households_lighting_low_energy_light_bulb_share: >
    Incandescent light bulbs waste a lot of energy. The power they consume
    is mostly turned into heat instead of light. That is why, in Europe,
    we will all shift to low-energy lighting in the coming years. These
    new light bulbs emit the same amount of light and do not become so
    warm. They even last much longer than traditional light bulbs!

  transport_cars_electric_share: >
    An electric car uses 2 to 3 times less enegry than a diesel or
    gasoline-powered car. Diesel and gasoline are made from oil. By
    switching to electric cars, we will save a lot of oil and use a bit
    more electricity. If we generate this electricity using wind turbines
    or solar power, driving a car will no longer produce any CO2
    emissions.

  households_insulation_level_old_houses: >
    Houses will lose a lot of energy because they have not been properly
    insulated. Of course, generating the energy we need in a sustainable
    way is a good idea. It is even better, though, to make sure we use
    less energy in the first place. A good way to do this is better
    insualtion for our homes.

  households_hot_water_solar_water_heater_share: >
    A solar water heater uses heat from the sun to make warm water. This
    is often done on the roof of a house. The hot water can then be used
    for showering or washing dishes, for example. By using the suns heat,
    we need a lot less energy to make hot water.

  households_behavior_standby_killer_turn_off_appliances: >
    We own more and more electrical appliances which are often left on
    when they are not being used. By switching off these appliances we can
    save power.

  households_heating_heat_pump_ground_share: >
    A heat pump is like a refrigerator used the other way around: it pumps
    heat into the house from outside, while a refrigerator pumps heat
    outside of its own insides. Heat pumps make sure that you need a lot
    less gas to heat the house. This is a good thing; we want to save that
    gas since it will not be available for ever.

  number_of_coal_conventional: >
    A coal-fired power plant is almost always running, producing
    electricity at maximum power. Powering it doen regularly reduces the
    amount of electricity we can make from coal. A coal-fired power plant
    produces more air polluation than any alternative. CO2 emissions are
    twice as high as for a gas-fired power plant.

  number_of_gas_conventional: >
    A gas-fired power plant is cheaper to build than a coal power plant.
    However, they cost more than power plants which burn coal. A gas-fired
    power plant is easily powered up or down. That can come in handy when
    wind turbines are not turning for a lack of wind. CO2 emissions are
    half that of a coal-fired power plant.

  number_of_nuclear_3rd_gen: >
    A nuclear power plant is quite expensive to build. However, they do
    last a lot longer than power plants which burn gas or coal. Once the
    power plant has been built, making electricity is cheap. That is why
    this type of power plant is almost always running. It cannot be used
    to balance the supply and demand of electricity. One advantage is that
    there are almost no CO2 emissions. The radioactive waste is a
    disadvantage. No one has come up with a good solution for this problem
    yet.

  number_of_wind_onshore_land: >
    A wind turbine produces sustainable power. There are no CO2 emissions.
    Wind is its fuel; it is a fuel which does not run out. Of course, the
    wind does not always blow. This means that building windmills alone is
    not enough. You would have a problem if you needed power and there was
    no wind. A lot of effort is currently being put into making wind
    turbines cheaper.

  number_of_solar_pv_roofs_fixed: >
    Solar panels make electricity when they absorb sublight. This also
    works on cloudy days. As a result, it is easier to predict how much
    power you can expect then it is with wind power. Of course, a solar
    panel in sunny Spain produces more electricity than one in the United
    Kingdom. You can install solar panels on the roof of your own house.
    This is useful: it avoids power losses from transporting electricity
    over a long cable. Solar panels are still quite expensive; a lot of
    work is being put into making them cheaper.

  policy_area_biomass: >
    Biomass in the remains of plans and trees (like hay, wood chips,
    branches, and saw dust). You can make power by burning biomass. An
    advantage is that biomass will never be exhausted, like coal or oil
    will. Of course, you do have to make sure to plant new trees and
    plants! CO2 is released into the air when you burn biomass. The good
    thing about using biomass is that those trees and plans absorbed a
    large part of this CO2 from the air during their lifetime.

nl:
  households_lighting_low_energy_light_bulb_share: >
    Gloeilampen verspillen veel energie. Bijna alle stroom die ze
    gebruiken wordt omgezet in warmte in plaats ven licht. Daarom zullen
    we Europa de komende jaren overschakelen naar zuinige lampen die veel
    minder warm worden en evenveel licht geven. Daar komt nog eens bij dat
    ze veel langer meegaan de gloeilampen.

  transport_cars_electric_share: >
    Een elektrische auto gebruikt 2 tot 3 keer minder energie dan een auto
    op benzine of diesel. Benzine en diesel worden uit olie gemaakt. Met
    elektrische auto's besparen we dus heel veel olie en gebruiken we een
    beetje meer elektriciteit. Als we deze elektriciteit opwekken met wind
    of zon, dan heeft autorijden geen CO2-uitstoot meer tot gevolg.

  households_insulation_level_old_houses: >
    Er gaat heel veel warmte verloren doordat huizen niet goed geïsoleerd
    zijn. Het is natuurlijk goed om energie die we nodig hebben duurzaam
    op te wekken. Maar het is natuurlijk nog beter om te zorgen dat we
    minder energie gebruiken. Dit kan door onze huizen beter te isoleren.

  households_hot_water_solar_water_heater_share: >
    Een zonneboiler benut warmte van de zon om water te verwarmen. Dit
    water zit in een reservoir op het dak van het huis. Het verwarmde
    water kan vervolgens gebruikt worden om af te wassen of te douchen.
    Op deze manier is veel minder energie nodig om water te verwarmen.

  households_behavior_standby_killer_turn_off_appliances: >
    We hebben steeds meer elektrische apparaten in huis. Heel vaak staan
    deze apparaten aan zonder dat we ze gebruiken. Door deze apparaten zo
    vaak mogelijk uit te zetten, kunnen we dus stroom besparen.

  households_heating_heat_pump_ground_share: >
    Een warmtepomp is een soort omgekeerde koelkast. Hij pompt warmte van
    buiten het huis naar binnen, terwijl een koelkast warmte van binnen de
    koelkast naar buiten pompt. Warmtepompen zorgen ervoor dat je veel
    minder gas hoeft te verbranden om je huis te verwarmen. Dat is goed.
    We willen zuinig zijn op gas omdat het niet eindeloos beschikbaar is.

  number_of_coal_conventional: >
    Een kolencentrale draait het grootste deel van de tijd op volle
    kracht. Regelmatig uitzetten verlaagt de hoeveelheid stroom die we
    uit kolen kunnen halen. Van alle manieren om stroom te maken geeft een
    kolencentrale de grootste luchtvervuiling. De CO2-uitstoot is ongeveer
    2 keer zo groot als die van een gascentrale.

  number_of_gas_conventional: >
    Een gascentrale is goedkoper om te bouwen dan een kolencentrale. Wel
    zijn ze duurder als ze draaien dan centrales op kolen. Een gascentrale
    kun je makkelijk aan of uit zetten. Dat is handig om stroom te makken
    als de windmolen even stilstaat om dat het niet  waait. De
    CO2-uitstoot van een gascentrale is ongeveer de helft van een
    kolencentrale.

  number_of_nuclear_3rd_gen: >
    Een kerncentrale is heel durr om te bouwen. Een kerncentrale gaat wel
    langer mee dan een kolen- of gascentrale. Als de centrale er eenmaal
    staat is het hoedkoop om stroom te maken. Daarom staat de centrale
    bijna altijd op volle kracht aan. Een kerncentrale is niet geschikt om
    vraag en aanbod ven stroom in evenwicht te brengen. Voordeel is dat je
    nauwelijks last hebt van CO2-uitstoot. Nadeel is het radioactieve
    afval dar overblijft. Hiervoor is nog geen goede oplossing bedacht.

  number_of_wind_onshore_land: >
    Een windmolen produceert duurzame stroom omdat je geen last hebt van
    CO2-uitstoot. Wind wordt als brandstof gebruikt. En wind is
    onuitputtelijk aanwezig. Het waait allen niet altijd. Daarom kun je
    niet volstaan met alleen windmolens. Dat heb je een probleem als je
    stroom nodig hebt en het waait niet. Er wordt momenteel hard gewerkt
    om te zorgen dat windmolens goedkoper worden.

  number_of_solar_pv_roofs_fixed: >
    Zonnepanelen maken stroom als ze zonlicht opvangen. Dit lukt trouwens
    ook als het bewolkt is. Daarom weet je van tevoren beter hoeveel
    stroom je kunt verwachten dan bij een windmolen. Het is wel zo dat een
    zonnepaneel in het zonnige Spanje meer stroom oplevert dan in
    Nederland. Zonnepanelen kun je op je eigen huis leggen. Dat is nuttig.

  policy_area_biomass: >
    Met biomassa wordt vooral het afval van planten en bomen bedoeld
    (hooi, houtsnippers, takken, zaagsel). Je kan stroom maken door
    biomassa te verbranden. Voordeel is dat biomassa niet uitgeput raakt
    zoals kolen en olie. Je moet dan natuurlijk wel zorgen dat er altijd
    voldoende nieuwe planten en boomen bijkomen! Als je biomassa verbrandt
    komt er CO2 in de lucht. Het mooie can biomassa is dat de boom of
    plant tijdens zijn leven al een groot deel van deze CO2 uit de lucht
    heeft opgenomen.
YAMLDOC
