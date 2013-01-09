json.position location
json.groups(groups) do |json, (group, inputs)|
  json.partial! 'embeds/group', group: group, inputs: inputs
end
