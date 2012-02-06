json.array!(@scenes) do |json, scene|
  @scene = scene
  render template: 'scenes/show', locals: { json: json }
end
