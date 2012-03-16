json.(@scenario, :end_year, :country)

json.guestName    @scenario.guest_name
json.sessionId    @scenario.session_id
json.inputValues  @scenario.input_values
json.queryResults @scenario.query_results

json.user do |json|
  if @scenario.user
    json.partial! 'embeds/user',  user: @scenario.user
  else
    json.partial! 'embeds/guest', user: Guest.new(@scenario.guest_uid)
  end
end

json.scene do |json|
  @scene = @scenario.scene
  render template: 'scenes/show', locals: { json: json }
end
