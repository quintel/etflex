FactoryGirl.define do
  factory :dual_bar_graph, class: Props::DualBarGraph do
    name 'electricity supply and demand'

    left_query_key  'query_key'
    right_query_key 'query_key'

    left_extent  1000
    right_extent 1000
  end

  factory :gauge, class: Props::Gauge do
    name      'balance of supply and demand'
    query_key 'balance_of_supply_and_demand'

    min 0.4
    max 1.6
  end
end
