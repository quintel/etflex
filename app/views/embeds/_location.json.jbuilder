json.position location
json.groups(groups) do |(group, inputs)|
  json.partial! 'embeds/group', group: group, inputs: inputs
end
