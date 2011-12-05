json.inputs(@inputs) do |json, input|
  json.partial! 'input', input: input
end
