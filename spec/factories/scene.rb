FactoryGirl.define do
  factory :scene do
    name 'Balancing Supply and Demand'
    name_key 'modern'
    score_gquery 'etflex_score'

    factory(:detailed_scene) { after(:create) do |scene|
      # Create two props, and add a scene prop for each one.

      scene.scene_props.create!(
        prop_id: FactoryGirl.create(:prop).id, location: 'center')

      scene.scene_props.create!(
        prop_id: FactoryGirl.create(:prop).id, location: 'bottom')
    end }

  end
end
