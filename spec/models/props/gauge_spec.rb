require 'spec_helper'

describe Props::Gauge do
  it { should be_mongoid_document }
  it { should be_stored_in(:props) }

  it { should embed_many(:states).of_type(Props::State) }

  it { should validate_presence_of(:query_key) }

  it { should validate_presence_of(:min) }
  it { should validate_presence_of(:max) }

  it { should validate_numericality_of(:min) }
  it { should validate_numericality_of(:max) }
end
