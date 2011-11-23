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

  context '#left?' do
    it 'should be true when placement=0' do
      SceneInput.new(placement: false).should be_left
    end

    it 'should be false when placement=1' do
      SceneInput.new(placement: true).should_not be_left
    end
  end

  context '#right?' do
    it 'should be false when placement=0' do
      SceneInput.new(placement: false).should_not be_right
    end

    it 'should be true when placement=1' do
      SceneInput.new(placement: true).should be_right
    end
  end

end
