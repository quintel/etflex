require 'spec_helper'

describe Props::State do
  it { should belong_to(:prop) }
  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:value) }
  it { should validate_numericality_of(:value) }
end
