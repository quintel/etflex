require 'spec_helper'

describe BlueprintInput do

  # BLUEPRINT ID -------------------------------------------------------------

  it { should validate_presence_of(:blueprint_id) }

  # INPUT ID -----------------------------------------------------------------

  it { should validate_presence_of(:input_id) }

  # POSITION -----------------------------------------------------------------

  it { should validate_presence_of(:position) }
  it { should validate_numericality_of(:position) }

  # PLACEMENT ----------------------------------------------------------------

  context '#left?' do
    it 'should be true when placement=0' do
      BlueprintInput.new(placement: false).should be_left
    end

    it 'should be false when placement=1' do
      BlueprintInput.new(placement: true).should_not be_left
    end
  end

  context '#right?' do
    it 'should be false when placement=0' do
      BlueprintInput.new(placement: false).should_not be_right
    end

    it 'should be true when placement=1' do
      BlueprintInput.new(placement: true).should be_right
    end
  end

end
