json.array!(@scenarios) do |scenario|
  @scenario = scenario
  render template: 'scenarios/show', locals: { json: json }
end
