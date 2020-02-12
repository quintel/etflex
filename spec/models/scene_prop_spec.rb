require 'spec_helper'

describe SceneProp do

  it { should validate_presence_of(:scene_id) }
  it { should validate_presence_of(:prop_id) }

  it { should validate_presence_of(:location) }
  it { should validate_length_f(:location).is_at_least(1).is_at_most(50) }

  # KEY ----------------------------------------------------------------------

  describe '#key' do
    subject { build :scene_prop }

    it 'should be delegated to the prop' do
      subject.key.should_not be_nil
      subject.key.should eql(subject.prop.key)
    end

    it 'should return nil when no prop is set' do
      SceneProp.new.key.should be_nil
    end

    it 'should not be writable' do
      expect { subject.key = 'another' }.to raise_error(NoMethodError)
    end
  end

  # BEHAVIOUR ----------------------------------------------------------------

  describe '#behaviour' do
    subject { build :scene_prop }

    it 'should be delegated to the prop' do
      subject.behaviour.should_not be_nil
      subject.behaviour.should eql(subject.prop.behaviour)
    end

    it 'should return nil when no prop is set' do
      SceneProp.new.behaviour.should be_nil
    end

    it 'should not be writable' do
      expect { subject.behaviour = 'another' }.to raise_error(NoMethodError)
    end
  end

end
