require 'spec_helper'

describe SceneInput do

  # RELATIONSHIPS ------------------------------------------------------------

  it { should belong_to(:scene) }
  it { should belong_to(:input) }

  # SCENE ID -----------------------------------------------------------------

  it { should validate_presence_of(:scene_id) }

  # INPUT ID -----------------------------------------------------------------

  it { should validate_presence_of(:input_id) }

  # PLACEMENT ----------------------------------------------------------------

  context 'when left: true' do
    subject { SceneInput.new(left: true) }

    it { should be_left }
    it { should_not be_right }
  end

  context 'when left: false' do
    subject { SceneInput.new(left: false) }

    it { should_not be_left }
    it { should be_right }
  end

end
