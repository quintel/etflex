class Blueprint < ActiveRecord::Base

  # RELATIONSHIPS ------------------------------------------------------------

  with_options class_name: 'BlueprintInput' do |opts|
    opts.has_many :left_blueprint_inputs,  conditions: { placement: false }
    opts.has_many :right_blueprint_inputs, conditions: { placement: true  }
  end

  with_options class_name: 'Input', source: :input, readonly: true do |opts|
    opts.has_many :left_inputs,  through: :left_blueprint_inputs
    opts.has_many :right_inputs, through: :right_blueprint_inputs
  end

  # VALIDATION ---------------------------------------------------------------

  validates :name, presence: true

end
