json.key group

json.inputs(inputs) do |input|
  json.partial! "embeds/inputs/#{input.type}", input: input
end
