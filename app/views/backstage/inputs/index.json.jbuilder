json.array!(@inputs) do |json, input|
  json.(input, :id, :key, :start, :min, :max, :step, :unit)
  json.remoteId input.remote_id
end
