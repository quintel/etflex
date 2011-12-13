require 'spec_helper'

describe SceneProp do

  it { should validate_presence_of(:scene_id) }
  it { should validate_presence_of(:prop_id) }

  it { should validate_presence_of(:location) }
  it { should ensure_length_of(:location).is_at_least(1).is_at_most(50) }

end
