json.remoteId input.remote_id

json.(input, :key, :start, :min, :max, :step, :unit, :position)
json.location ( if input.left? then 'left' else 'right' end )
