require 'spec_helper'

describe SceneInput do

  it { should be_embedded_in(:scene) }
  it { should belong_to(:input) }

  # INPUT ID -----------------------------------------------------------------

  it { should validate_presence_of(:input_id) }
  xit { should validate_uniqueness_of(:input_id).scoped_to(:scene_id) }

  # LEFT ---------------------------------------------------------------------

  describe 'left' do
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

  # ID -----------------------------------------------------------------------

  describe '#remote_id' do
    subject { SceneInput.new(input: Input.new(id: 5)) }

    it 'should be an integer' do
      subject.remote_id.should be_kind_of(Integer)
    end

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

  # INPUT --------------------------------------------------------------------

  describe '#input' do
    let(:input) { create :input }
    subject { SceneInput.new input: input }

    context 'when a #scene is set' do
      let(:scene) { build(:scene).tap { |s| s.scene_inputs.push(subject) } }

      it 'should call Scene#input' do
        scene.should_receive(:input).with(subject).once
        subject.input
      end

      it 'should return the correct input' do
        subject.input.should eql(input)
      end

      it 'should not call Scene#Input if reloading' do
        scene.should_not_receive(:input)
        subject.input(:reload)
      end

      context 'and no input is set' do
        before(:each) { subject.input = nil }

        it 'should not call Scene#input' do
          scene.should_not_receive(:input)
        end

        it 'should return nil' do
          subject.input.should be_nil
        end
      end
    end # when a #scene is set

    context 'when no #scene is set' do
      it 'should return the correct input' do
        subject.input.should eql(input)
      end
    end # when no #scene is set
  end # #input

end
