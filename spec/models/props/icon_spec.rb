require 'spec_helper'

describe Props::Icon do
  it { should be_mongoid_document }
  it { should be_stored_in(:props) }

  it { should embed_many(:states) }

  it { should validate_presence_of(:query_key) }
end
