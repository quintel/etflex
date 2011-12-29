json.scenes(@scenes) do |json, scene|
  json.partial! 'embeds/scene', scene: scene
end
