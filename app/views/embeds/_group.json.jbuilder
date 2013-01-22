json.key group

json.inputs(inputs) do |json, input|
  json.partial! "embeds/inputs/#{input.type}", input: input
end
