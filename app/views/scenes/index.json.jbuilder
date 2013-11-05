json.array!(@scenes) do |scene|
  @scene = scene
  render template: 'scenes/show', locals: { json: json }
end
