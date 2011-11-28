require 'spec_helper'

describe SceneProp do
  it { should validate_presence_of(:scene_id) }
  it { should validate_presence_of(:prop_id) }
  it { should validate_presence_of(:prop_type) }
end
