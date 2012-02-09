class AddQueryExtremaToSceneProps < ActiveRecord::Migration
  EXTREMA = {
    co2_emissions: {
      'total_co2_emissions' => {
        'nl' => [ 85, 168 ],
        'uk' => [ 275, 539 ],
        'de' => [ 530, 770 ] } } }

  HURDLES = {
    co2_emissions: [ 0.5, 0.66, 0.83 ] }

  def up
    add_column :scene_props, :query_extrema, :text

    EXTREMA.each do |(prop_key, queries)|
      prop = Prop.where(key: prop_key).first

      SceneProp.where(prop_id: prop.id).each do |scene_prop|
        scene_prop.query_extrema = queries
        scene_prop.hurdles = HURDLES[ prop_key ]

        scene_prop.save!
      end
    end # EXTREMA.each
  end

  def down
    remove_column :scene_props, :query_extrema

    say 'The query_extrema column has been removed, however the scene ' \
        'prop hurdle'
    say 'values must be reverted manually. Run db:seed.'
  end
end
