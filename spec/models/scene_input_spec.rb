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

  # MIN ----------------------------------------------------------------------

  describe '#min' do
    subject { SceneInput.new(input: Input.new(min: 50)) }

    it 'should return the value when set' do
      subject.min = 75
      subject.min.should eql(75.0)
    end

    it 'should delegate to the input when no value is set' do
      subject.min.should eql(50.0)
    end

    it 'should return nil if no value, and no input is set' do
      SceneInput.new.min.should be_nil
    end
  end

  # MAX ----------------------------------------------------------------------

  describe '#max' do
    subject { SceneInput.new(input: Input.new(max: 50)) }

    it 'should return the value when set' do
      subject.max = 75
      subject.max.should eql(75.0)
    end

    it 'should delegate to the input when no value is set' do
      subject.max.should eql(50.0)
    end

    it 'should return nil if no value, and no input is set' do
      SceneInput.new.max.should be_nil
    end
  end

  # START --------------------------------------------------------------------

  describe '#start' do
    subject { SceneInput.new(input: Input.new(start: 50)) }

    it 'should return the value when set' do
      subject.start = 75
      subject.start.should eql(75.0)
    end

    it 'should delegate to the input when no value is set' do
      subject.start.should eql(50.0)
    end

    it 'should return nil if no value, and no input is set' do
      SceneInput.new.start.should be_nil
    end
  end

end
