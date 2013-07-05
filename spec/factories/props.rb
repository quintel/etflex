FactoryGirl.define do
  prop_behaviours = YAML.load_file('config/prop_map.yml').map(&:first)

  factory :prop do
    sequence(:behaviour) { |n| prop_behaviours[n % prop_behaviours.length] }
    key                  { behaviour.underscore  }
  end

  factory :scene_prop do
    association :prop
  end
end
