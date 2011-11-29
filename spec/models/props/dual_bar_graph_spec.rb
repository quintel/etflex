require 'spec_helper'

describe Props::DualBarGraph do
  it { should be_mongoid_document }
  it { should be_stored_in(:props) }
  it { should successfully_save }

  it { should validate_presence_of(:left_query_key) }
  it { should validate_presence_of(:right_query_key) }

  it { should validate_presence_of(:left_extent) }
  it { should validate_presence_of(:right_extent) }
  it { should validate_numericality_of(:left_extent) }
  it { should validate_numericality_of(:right_extent) }
end
