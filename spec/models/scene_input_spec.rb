require 'spec_helper'

describe SceneInput do

  it { should belong_to(:input) }
  it { should belong_to(:scene) }

  it { should allow_mass_assignment_of(:input_id) }
  it { should allow_mass_assignment_of(:location) }
  it { should allow_mass_assignment_of(:position) }
  it { should allow_mass_assignment_of(:step) }
  it { should allow_mass_assignment_of(:min) }
  it { should allow_mass_assignment_of(:max) }
  it { should allow_mass_assignment_of(:step) }
  it { should allow_mass_assignment_of(:start) }
  it { should allow_mass_assignment_of(:information_en) }
  it { should allow_mass_assignment_of(:information_nl) }

  it { should_not allow_mass_assignment_of(:scene_id) }

  # INPUT ID -----------------------------------------------------------------

  it { should validate_presence_of(:input_id) }
  it {
    SceneInput.create!(input_id: 1, location: 'l') { |si| si.scene_id = 1 }
    should validate_uniqueness_of(:input_id).scoped_to(:scene_id) }

  # LOCATION -----------------------------------------------------------------

  describe 'location' do
    it { should validate_presence_of(:location) }
  end

  # STEP ---------------------------------------------------------------------

  describe '#step' do
    subject { SceneInput.new(input: Input.new(step: 50)) }

    it 'should return the value when set' do
      subject.step = 75
      subject.step.should eql(75.0)
    end

    it 'should delegate to the input when no value is set' do
      subject.step.should eql(50.0)
    end

    it 'should return nil if no value, and no input is set' do
      SceneInput.new.step.should be_nil
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

    # Minimum must not be less than input minimum...

    it 'should not be higher than the Input min' do
      subject.min = 49

      subject.errors_on(:min).should include(
        'must be greater than or equal to 50.0')
    end

    it 'should ignore the input minimum when no input is set' do
      subject.input = nil
      subject.should have(:no).errors_on(:min)
    end

    it 'should ignore the input minimum when none is set' do
      subject.input.max = nil
      subject.should have(:no).errors_on(:min)
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

    # Maximum must not be less than input maximum...

    it 'should not be higher than the Input max' do
      subject.max = 51

      subject.errors_on(:max).should include(
        'must be less than or equal to 50.0')
    end

    it 'should ignore the input maximum when no input is set' do
      subject.input = nil
      subject.should have(:no).errors_on(:max)
    end

    it 'should ignore the input maximum when none is set' do
      subject.input.max = nil
      subject.should have(:no).errors_on(:max)
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
    let(:input) { create :input }
    subject { SceneInput.new(input: input) }

    it 'should be an integer' do
      subject.remote_id.should be_kind_of(Integer)
    end

    it 'should be delegated to the input' do
      subject.remote_id.should eql(input.remote_id)
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

  # GROUP --------------------------------------------------------------------

  describe '#group' do
    let(:input) { create :input, group: 'my-group' }
    subject { SceneInput.new(input: input) }

    it 'should be a string' do
      subject.group.should be_kind_of(String)
    end

    it 'should be delegated to the input' do
      subject.group.should eql(input.group)
    end

    it 'should return nil when no input is set' do
      SceneInput.new.group.should be_nil
    end

    it 'should not be writable' do
      expect { subject.group = 'thing' }.to raise_error(NoMethodError)
    end
  end

  # SIBLINGS -----------------------------------------------------------------

  describe 'siblings' do
    let(:scene)     { create :scene_with_inputs }
    let(:focus)     { scene.scene_inputs.first }
    let(:sibling_1) { create :input, group: 'my-group' }
    let(:sibling_2) { create :input, group: 'my-group' }

    before do
      scene ; sibling_1 ; sibling_2
      focus.input.update_attributes! group: 'my-group'
    end

    describe 'when given a single, grouped scene input with two siblings' do
      subject { SceneInput.siblings focus }
      let(:inputs) { subject.map(&:input) }

      it 'should contain the siblings' do
        should have(2).members
      end

      it 'should contain SceneInput instances' do
        subject.each { |sibling| sibling.should be_a(SceneInput) }
      end

      it 'should contain the first sibling' do
        inputs.should include(sibling_1)
      end

      it 'should contain the second sibling' do
        inputs.should include(sibling_2)
      end

      it 'should not include the focused input' do
        inputs.should_not include(focus.input)
      end
    end
  end
end
