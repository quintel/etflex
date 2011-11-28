require 'spec_helper'

describe Props::State do
  it { should be_mongoid_document }

  it { should be_embedded_in(:stateful) }

  it { should validate_presence_of(:key) }
  it { should validate_presence_of(:value) }
  it { should validate_numericality_of(:value) }
end
