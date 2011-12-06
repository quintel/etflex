# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts  'Seeding will remove EVERYTHING from the DB. Are you sure?'
print 'Enter "yes" or "y" to continue; anything else will abort: '

unless $stdin.gets.chomp =~ /^y(es)?$/
  puts 'Aborted. Goodbye.'
  exit 0
end

puts 'Removing old records...'

Mongoid.database.collections.each do |collection|
  collection.drop unless collection.name.match(/^system\./)
end

# INPUTS ---------------------------------------------------------------------

puts 'Importing inputs...'

YAML.load_file(Rails.root.join('db/seeds/inputs.yml')).each do |data|
  unless Input.create(data)
    raise "Failed to save input: #{data['key']}, #{input.errors.inspect}"
  end
end

# PROPS ----------------------------------------------------------------------

puts 'Importing props...'

YAML.load_file(Rails.root.join('db/seeds/props.yml')).each do |data|
  klass  = Props.const_get(data.delete('type'))
  states = data.delete('states')

  prop = klass.new(data)

  if states.present?
    states.each { |key, value| prop.states.build(key: key, value: value) }
  end

  prop.save!
end

# SCENES ---------------------------------------------------------------------

puts 'Importing scenes...'

YAML.load_file(Rails.root.join('db/seeds/scenes.yml')).each do |data|
  scene  = Scene.new name: data['name']
  props  = data.delete('props') || []
  inputs = data.delete('inputs') || {}

  # Props.

  props.each do |(location, keys)|
    keys.each do |key|
      scene.scene_props.build(
        location: location,
        prop:     Props::Base.where(name: key).first
      )
    end
  end

  # Inputs.

  inputs.each do |(location, ids)|
    ids.each do |remote_id|
      scene.scene_inputs.build(
        left:  location == 'left',
        input: Input.find(remote_id)
      )
    end
  end

  scene.save!
end

# ----------------------------------------------------------------------------

puts 'All done'
