json.(@scene, :id, :name, :name_key)
json.href scene_path(@scene.id)

# We need to send the $internal inputs which are used to balance groups when
# not all sliders are visible to the user.
scene_inputs = SceneInput.siblings(@scene.scene_inputs) + @scene.scene_inputs

json.inputs(scene_inputs) do |json, input|
  json.partial! 'embeds/input', input: input
end

json.props(@scene.scene_props) do |json, prop|
  json.partial! 'embeds/prop', prop: prop
end
