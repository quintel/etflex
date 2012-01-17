json.(@scenario, :id)
json.sessionId @scenario.session_id

json.user do |json|
  json.partial! 'embeds/user', user: @scenario.user
end

json.scene do |json|
  @scene = @scenario.scene
  render template: 'scenes/show', locals: { json: json }
end
