class ChangeCityPropToAddSmogAtUnder2mCars < ActiveRecord::Migration
  def with_city
    prop = Prop.where(key: 'city').first

    SceneProp.where(prop_id: prop.id).all.each do |prop|
      yield prop
      prop.save!
    end
  end

  def up
    with_city { |prop| prop.hurdles = [ 2_000_000 ] }
    say 'Updated city hurdle to [ 2,000,000 ]'
  end

  def down
    with_city { |prop| prop.hurdles = [ 200, 422 ] }
    say 'Reverted city hurdle to [ 200, 422 ]'
  end
end
