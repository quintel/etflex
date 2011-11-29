FactoryGirl.define do
  factory :scene do
    name 'My First Scene'
  end

  factory :scene_with_key, class: Scene do
    name_key 'my_first_scene'
  end
end
