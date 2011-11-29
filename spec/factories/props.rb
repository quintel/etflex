FactoryGirl.define do
  factory :dual_bar_graph, class: Props::DualBarGraph do
    name 'electricity supply and demand'

    left_query_key  'query_key'
    right_query_key 'query_key'

    left_extent  1000
    right_extent 1000
  end
end
