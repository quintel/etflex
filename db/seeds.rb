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

Input.delete_all
Prop.delete_all
Scene.delete_all
SceneInput.delete_all
SceneProp.delete_all
User.delete_all

# INPUTS ---------------------------------------------------------------------

puts 'Importing inputs...'

YAML.load_file(Rails.root.join('db/seeds/inputs.yml')).each do |data|
  Input.create!(data)
end

# INPUTS ---------------------------------------------------------------------

puts 'Importing props...'

YAML.load_file(Rails.root.join('db/seeds/props.yml')).each do |data|
  Prop.create!(data)
end

# SCENES ---------------------------------------------------------------------

puts 'Importing scenes...'

Scene.connection.execute('ALTER TABLE scenes AUTO_INCREMENT = 1;')

YAML.load_file(Rails.root.join('db/seeds/scenes.yml')).each do |data|
  scene  = Scene.create name: data['name']
  inputs = data.delete('inputs') || {}
  props  = data.delete('props')  || {}

  # Inputs.

  inputs.each do |(location, ids)|
    ids.each do |(remote_id, data)|
      data = data.symbolize_keys

      scene.scene_inputs.build((data || {}).merge(
        location: location,
        input:    Input.where(remote_id: remote_id).first
      ))
    end
  end

  # Props.

  props.each do |(location, keys)|
    keys.each_with_index do |(behaviour, hurdles),index|
      scene.scene_props.build(
        location: location,
        position: index,
        prop:     Prop.where(behaviour: behaviour).first,
        hurdles:  hurdles
      )
    end
  end

  scene.save!
end

# ADMIN USER FOR BACKSTAGE ---------------------------------------------------

puts "Setting admin user..."

User.create!(email: 'admin@quintel.com', password: 'Energy') do |user|
  user.admin = true
end

# ----------------------------------------------------------------------------

puts 'All done'
