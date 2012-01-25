json.(@scenario, :id)

json.sessionId    @scenario.session_id
json.inputValues  @scenario.input_values
json.queryResults @scenario.query_results

json.user do |json|
  if user_signed_in?
    json.partial! 'embeds/user', user: @scenario.user
  else
    json.partial! 'embeds/guest', user: guest_user
  end
end

json.scene do |json|
  @scene = @scenario.scene
  render template: 'scenes/show', locals: { json: json }
end
