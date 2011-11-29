require 'spec_helper'

describe Props::Icon do
  it { should have_many(:states).class_name(Props::State) }
  it { should validate_presence_of(:query_id) }
end
