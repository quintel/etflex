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
Mongoid.database.collections.each { |collection| collection.remove }

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
  klass = Props.const_get(data['type'])
  klass.create!(data.except('type'))
end

# SCENES ---------------------------------------------------------------------

puts 'Importing scenes...'

YAML.load_file(Rails.root.join('db/seeds/scenes.yml')).each do |data|
  scene = Scene.new name: data['name']

  unless scene.save
    raise "Failed to save scene: #{data['name']}, #{scene.errors.inspect}"
  end

  # Props.

  if data['center_props']
    data['center_props'].each do |name_key|
      scene.center_props.push(Prop.where(name: name_key).first)
    end

    scene.save!
  end

  # Inputs.

  data['left_inputs'].each do |input|
    scene.scene_inputs.create!(
      left:  true,
      input: Input.where(remote_id: input).first)
  end

  data['right_inputs'].each do |input|
    scene.scene_inputs.create!(
      left:  false,
      input: Input.where(remote_id: input).first)
  end
end

# ----------------------------------------------------------------------------

puts 'All done'
