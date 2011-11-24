require 'spec_helper'

describe SceneInput do

  # RELATIONSHIPS ------------------------------------------------------------

  it { should belong_to(:scene) }
  it { should belong_to(:input) }

  # SCENE ID -----------------------------------------------------------------

  it { should validate_presence_of(:scene_id) }

  # INPUT ID -----------------------------------------------------------------

  it { should validate_presence_of(:input_id) }

  # LEFT ---------------------------------------------------------------------

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

  # REMOTE ID ----------------------------------------------------------------

  describe '#remote_id' do
    subject { SceneInput.new(input: Input.new(remote_id: 5)) }

    it 'should be delegated to the input' do
      subject.remote_id.should eql(5)
    end

    it 'should return nil when no input is set' do
      SceneInput.new.remote_id.should be_nil
    end

    it 'should not be writable' do
      expect { subject.remote_id = 6 }.to raise_error(NoMethodError)
    end
  end

  # KEY ----------------------------------------------------------------------

  describe '#key' do
    subject { SceneInput.new(input: Input.new(key: 'hello')) }

    it 'should be delegated to the input' do
      subject.key.should eql('hello')
    end

    it 'should return nil when no input is set' do
      SceneInput.new.key.should be_nil
    end

    it 'should not be writable' do
      expect { subject.key = 'another' }.to raise_error(NoMethodError)
    end
  end

  # STEP ---------------------------------------------------------------------

  describe '#step' do
    subject { SceneInput.new(input: Input.new(step: 50.0)) }

    it 'should be delegated to the input' do
      subject.step.should eql(50.0)
    end

    it 'should return nil when no input is set' do
      SceneInput.new.step.should be_nil
    end

    it 'should not be writable' do
      expect { subject.step = 25 }.to raise_error(NoMethodError)
    end
  end

  # UNIT ---------------------------------------------------------------------

  describe '#unit' do
    subject { SceneInput.new(input: Input.new(unit: 'PJ')) }

    it 'should be delegated to the input' do
      subject.unit.should eql('PJ')
    end

    it 'should return nil when no input is set' do
      SceneInput.new.unit.should be_nil
    end

    it 'should not be writable' do
      expect { subject.unit = 'TJ' }.to raise_error(NoMethodError)
    end
  end

end
