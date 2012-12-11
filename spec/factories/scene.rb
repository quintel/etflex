FactoryGirl.define do
  factory :scene do
    name 'My First Scene'
    name_key 'my_first_scene'
    score_property 'etflex_score'

    factory(:detailed_scene) { after(:create) do |scene|
      # Create two inputs, and add a scene input for each one.

      scene.scene_inputs.create!(
        input_id: FactoryGirl.create(:input).id, location: 'left')

      scene.scene_inputs.create!(
        input_id: FactoryGirl.create(:input).id, location: 'right',
        information_en: 'English')

      # Create two props, and add a scene prop for each one.

      scene.scene_props.create!(
        prop_id: FactoryGirl.create(:prop).id, location: 'center')

      scene.scene_props.create!(
        prop_id: FactoryGirl.create(:prop).id, location: 'bottom')
    end }

    factory(:scene_with_inputs) { after(:create) do |scene|
      # Create two inputs, and add a scene input for each one.

      input_one = FactoryGirl.create(:input, remote_id: 366,
        key: 'households_behavior_standby_killer_turn_off_appliances')

      input_two = FactoryGirl.create(:input, remote_id: 315,
        key: 'number_of_pulverized_coal')

      scene.scene_inputs.create!(location: 'left', input_id: input_one.id)

      scene.scene_inputs.create!(location: 'right', input_id: input_two.id,
        information_en: 'English')
    end }

  end
end
