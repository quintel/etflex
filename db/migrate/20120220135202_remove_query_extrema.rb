class RemoveQueryExtrema < ActiveRecord::Migration
  def up
    update_co2_props! do |prop|
      prop.hurdles =[ 140.0, 154.0, 161.0 ]
    end

    say 'Updated hurdle information'

    remove_column :scene_props, :query_extrema
  end

  def down
    add_column :scene_props, :query_extrema, :text

    SceneProp.reset_column_information

    update_co2_props! do |prop|
      prop.query_extrema = {
        'total_co2_emissions' => {
          'nl' => [ 85, 168 ],
          'uk' => [ 275, 539 ],
          'de' => [ 530, 770 ] } }

      prop.hurdles = [ 140.0, 154.0, 161.0 ]
    end

    say 'Updated hurdle and extrema information'
  end

  def update_co2_props!
    prop = Prop.where(key: 'co2_emissions').first

    SceneProp.where(prop_id: prop.id).each do |scene_prop|
      yield scene_prop
      scene_prop.save!
    end
  end
end
