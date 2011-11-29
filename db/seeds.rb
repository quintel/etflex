# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# INPUTS ---------------------------------------------------------------------

YAML.load_file(Rails.root.join('db/seeds/inputs.yml')).each do |data|
  unless Input.create(data)
    raise "Failed to save input: #{data['key']}, #{input.errors.inspect}"
  end
end

# PROPS ----------------------------------------------------------------------

YAML.load_file(Rails.root.join('db/seeds/props.yml')).each do |data|
  klass  = Props.const_get(data.delete('type'))
  states = data.delete('states') || []
  prop   = klass.new(data)

  states.each { |(key, value)| prop.states.build(key: key, value: value) }

  prop.save!
end

# SCENES ---------------------------------------------------------------------

YAML.load_file(Rails.root.join('db/seeds/scenes.yml')).each do |data|
  scene = Scene.new name: data['name']

  unless scene.save
    raise "Failed to save scene: #{data['name']}, #{scene.errors.inspect}"
  end

  data['left_inputs'].each do |input|
    scene.left_scene_inputs.create!(
      input_id: Input.where(remote_id: input).first.id)
  end

  data['right_inputs'].each do |input|
    scene.right_scene_inputs.create!(
      input_id: Input.where(remote_id: input).first.id)
  end

  data['props'].each do |(klass_name, id)|
    klass = Props.const_get(klass_name)
    prop  = klass.find(id)

    scene.scene_props.create!(prop: prop)
  end
end
