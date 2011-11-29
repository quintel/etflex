require 'spec_helper'

describe Props::Gauge do
  it { should have_many(:states).class_name(Props::State) }

  it { should validate_presence_of(:query_id) }

  it { should validate_presence_of(:min) }
  it { should validate_numericality_of(:min) }

  it { should validate_presence_of(:max) }
  it { should validate_numericality_of(:max) }
end
