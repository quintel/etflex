require 'spec_helper'

describe Blueprint do
  # RELATIONSHIPS ------------------------------------------------------------

  it { should have_many(:left_blueprint_inputs).conditions(placement: false) }
  it { should have_many(:right_blueprint_inputs).conditions(placement: true) }

  it { should have_many(:left_inputs).through(:left_blueprint_inputs) }
  it { should have_many(:right_inputs).through(:right_blueprint_inputs) }

  # NAME ---------------------------------------------------------------------

  it { should validate_presence_of(:name) }
end
