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

Prop.delete_all
Scene.delete_all
SceneProp.delete_all
User.delete_all

# PROPS ----------------------------------------------------------------------

puts 'Importing props...'

YAML.load_file(Rails.root.join('db/seeds/props.yml')).each do |data|
  Prop.create!(data)
end

# SCENES ---------------------------------------------------------------------

puts 'Importing scenes...'

Scene.connection.execute('ALTER TABLE scenes AUTO_INCREMENT = 1;')

YAML.load_file(Rails.root.join('db/seeds/scenes.yml')).each do |data|
  props  = data.delete('props')  || {}

  scene  = Scene.create data

  # Props.
  props.each do |(location, keys)|
    keys.each_with_index do |behaviour, index|
      scene.scene_props.build.tap do |prop|
        prop.location = location
        prop.position = index
        prop.prop     = Prop.where(behaviour: behaviour).first
      end
    end
  end

  scene.save!
end

# ADMIN USER FOR BACKSTAGE ---------------------------------------------------

puts "Setting admin user..."

password = SecureRandom.hex[0..12]

User.create!(email: 'admin@quintel.com', password: password) do |user|
  user.name  = 'ETFlex Test'
  user.admin = true
end

puts "Saved: admin@quintel.com with password: #{ password }"

# ----------------------------------------------------------------------------

puts 'All done'
