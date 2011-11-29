require 'spec_helper'

describe SceneProp do

  it { should be_embedded_in(:scene) }
  it { should belong_to(:prop).of_type(Props::Base) }

  # PROP ID ------------------------------------------------------------------

  describe 'prop ID' do
    it { should validate_presence_of(:prop_id) }
  end

end
