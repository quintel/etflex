json.(@scene, :id, :name)
json.href scene_path(@scene.id)

json.inputs(@scene.scene_inputs) do |json, input|
  json.partial! 'embeds/input', input: input
end

json.props(@scene.scene_props) do |json, prop|
  json.partial! 'embeds/prop', prop: prop
end
