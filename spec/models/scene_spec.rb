require 'spec_helper'

describe Scene do

  # RELATIONSHIPS ------------------------------------------------------------

  it { should have_many(:scene_inputs) }
  it { should have_many(:left_scene_inputs).conditions(placement: false) }
  it { should have_many(:right_scene_inputs).conditions(placement: true) }

  it { should have_many(:inputs).through(:scene_inputs) }
  it { should have_many(:left_inputs).through(:left_scene_inputs) }
  it { should have_many(:right_inputs).through(:right_scene_inputs) }

  # NAME ---------------------------------------------------------------------

  it { should validate_presence_of(:name) }

end
