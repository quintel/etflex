json.(@scenario, :end_year, :country)

json.guestName    @scenario.guest_name
json.sessionId    @scenario.session_id
json.beagleboneId @scenario.beaglebone_id
json.inputValues  @scenario.input_values

if @scenario.query_results.empty? || @scenario.query_results.first.last.is_a?(Hash)
  # This is a new-style results hash, containing both present and future
  # values.
  json.queryResults @scenario.query_results
else
  # This is an old-style results hash containing only future values. We need
  # to convert it.
  json.queryResults(
    @scenario.query_results.each_with_object(Hash.new) do |(key, value), res|
      res[key] = { future: value }
    end
  )
end

json.user do |json|
  if @scenario.user
    json.partial! 'embeds/user',  user: @scenario.user
  else
    json.partial! 'embeds/guest', user: @scenario.user_or_guest
  end
end

json.scene do |json|
  @scene = @scenario.scene
  render template: 'scenes/show', locals: { json: json }
end
