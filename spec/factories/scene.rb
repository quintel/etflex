FactoryGirl.define do
  factory :scene do
    name 'My First Scene'

    factory :scene_with_key do
      name_key 'my_first_scene'
    end

    factory(:detailed_scene) { after_create do |scene|
      # Create two inputs, and add a scene input for each one.

      scene.scene_inputs.create!(
        input: FactoryGirl.create(:input), location: 'left')

      scene.scene_inputs.create!(
        input: FactoryGirl.create(:input), location: 'right',
        information_en: 'English')

      # Create two props, and add a scene prop for each one.

      scene.scene_props.create!(
        prop: FactoryGirl.create(:prop), location: 'center')

      scene.scene_props.create!(
        prop: FactoryGirl.create(:prop), location: 'bottom',
        hurdles: [1, 2, 3])
    end }

    factory(:scene_with_inputs) { after_create do |scene|
      # Create two inputs, and add a scene input for each one.

      input_one = FactoryGirl.create(:input, remote_id: 146,
        key: 'transport_cars_electric_share')

      input_two = FactoryGirl.create(:input, remote_id: 315,
        key: 'number_of_coal_conventional')

      scene.scene_inputs.create!(location: 'left', input: input_one)

      scene.scene_inputs.create!(location: 'right', input: input_two,
        information_en: 'English')
    end }

  end
end
