json.(@scene, :id, :name)
json.href scene_path(@scene.id)

json.inputs(@scene.scene_inputs) do |json, input|
  json.partial! 'embeds/input', input: input
end

json.centerVis 'supply-demand'
json.mainVis   %w( renewables co2-emissions costs )
