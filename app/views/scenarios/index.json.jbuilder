json.array!(@scenarios) do |json, scenario|
  @scenario = scenario
  render template: 'scenarios/show', locals: { json: json }
end
