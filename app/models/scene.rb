class Scene < ActiveRecord::Base

  # RELATIONSHIPS ------------------------------------------------------------

  with_options class_name: 'SceneInput' do |opts|
    opts.has_many :scene_inputs
    opts.has_many :left_scene_inputs,  conditions: { left: true  }
    opts.has_many :right_scene_inputs, conditions: { left: false }
  end

  with_options class_name: 'Input', source: :input, readonly: true do |opts|
    opts.has_many :inputs,       through: :scene_inputs
    opts.has_many :left_inputs,  through: :left_scene_inputs
    opts.has_many :right_inputs, through: :right_scene_inputs
  end

  # VALIDATION ---------------------------------------------------------------

  validates :name, presence: true

end
