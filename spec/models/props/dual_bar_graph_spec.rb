require 'spec_helper'

describe Props::DualBarGraph do
  it { should have_many(:states).class_name(Props::State) }

  it { should validate_presence_of(:left_extent) }
  it { should validate_presence_of(:right_extent) }

  it { should validate_numericality_of(:left_extent) }
  it { should validate_numericality_of(:right_extent) }
end
