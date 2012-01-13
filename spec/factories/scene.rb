FactoryGirl.define do
  factory :scene do
    name 'My First Scene'

    factory :scene_with_key do
      name_key 'my_first_scene'
    end

    factory(:detailed_scene) { after_create do |scene|
      # Create two inputs, and add a scene input for each one.

      scene.scene_inputs.create!(
        input: FactoryGirl.create(:input), location: 'left' )

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

  end
end
