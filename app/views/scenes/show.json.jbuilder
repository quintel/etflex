json.(@scene, :id, :name, :name_key, :score_gquery)
json.href scene_path(@scene.id)

json.inputs(@scene.inputs) do |json, (location, groups)|
  json.partial! 'embeds/location', location: location, groups: groups
end

json.props(@scene.scene_props) do |json, prop|
  json.partial! 'embeds/prop', prop: prop
end
