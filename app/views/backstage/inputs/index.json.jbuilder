json.array!(@inputs) do |json, input|
  json.(input, :id, :key, :start, :min, :max, :step, :unit)
  json.remoteId input.id
end
