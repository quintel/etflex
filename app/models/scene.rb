# Brings together Inputs and Props to create a "Scene" with which users may
# interact. An example is the default "Balancing Supply and Demand" scene
# which provides a range of energy-saving and power-generation options, and
# shows the user the effect of their choices on supply and demand, CO2
# emissions, etc.
#
# == Columns
#
# name (String[0..100])
#   A human readable name for the Scene. Useful for when visitors create their
#   own Scenes; they can't - and won't want to - set localised strings in each
#   language.
#
#   Staff should leave this blank, set a "name_key" instead.
#
# name_key (String[0..100])
#   "name_key" allows staff to omit a Scene name (since it would be limited
#   to one language) and provides the option of using an I18n key instead.
#
class Scene < ActiveRecord::Base

  default_scope do
    includes(scene_props: :prop, scene_inputs: :input)
  end

  attr_accessible :name, :name_key

  # RELATIONSHIPS ------------------------------------------------------------

  has_many :scene_props
  has_many :props, :through => :scene_props
  has_many :scenarios

  with_options class_name: 'SceneInput' do |opts|
    opts.has_many :scene_inputs
    opts.has_many :left_scene_inputs,   conditions:  { location: 'left'  }
    opts.has_many :right_scene_inputs,  conditions:  { location: 'right' }
    opts.has_many :hidden_scene_inputs, conditions:  { location: nil     }
  end

  with_options class_name: 'Input', source: :input, readonly: true do |opts|
    opts.has_many :inputs,        through: :scene_inputs
    opts.has_many :left_inputs,   through: :left_scene_inputs
    opts.has_many :right_inputs,  through: :right_scene_inputs
    opts.has_many :hidden_inputs, through: :hidden_scene_inputs
  end

  # VALIDATION ---------------------------------------------------------------

  validates_presence_of :name
  validates_length_of   :name, maximum: 100

  validates_presence_of :name_key
  validates_length_of   :name_key, maximum: 100
  validates_format_of   :name_key, with: /^[a-z0-9_-]+$/
end
