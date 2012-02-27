class RemoveHurdlesFromDb < ActiveRecord::Migration
  def up
    remove_column :scene_props, :hurdles
  end

  def down
    yaml = YAML.load_file Rails.root.join('db/seeds/scenes.yml')
    yaml = yaml.first['props']
    data = yaml.each_with_object({}) { |(_, props), obj| obj.merge! props }

    add_column :scene_props, :hurdles, :text

    SceneProp.reset_column_information

    SceneProp.all.each do |scene_prop|
      scene_prop.hurdles = data[ scene_prop.prop.behaviour ]
      scene_prop.save!
    end

    say 'Added hurdle info back to the DB'
  end
end
