require 'spec_helper'

describe SceneProp do

  it { should allow_mass_assignment_of(:scene_id) }
  it { should allow_mass_assignment_of(:scene) }
  it { should allow_mass_assignment_of(:prop_id) }
  it { should allow_mass_assignment_of(:prop) }
  it { should allow_mass_assignment_of(:location) }
  it { should allow_mass_assignment_of(:query_extrema) }

  it { should validate_presence_of(:scene_id) }
  it { should validate_presence_of(:prop_id) }

  it { should validate_presence_of(:location) }
  it { should ensure_length_of(:location).is_at_least(1).is_at_most(50) }

  # KEY ----------------------------------------------------------------------

  describe '#key' do
    subject { SceneProp.new(prop: Prop.new(key: 'hello')) }

    it 'should be delegated to the prop' do
      subject.key.should eql('hello')
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
    subject { SceneProp.new(prop: Prop.new(behaviour: 'hello')) }

    it 'should be delegated to the prop' do
      subject.behaviour.should eql('hello')
    end

    it 'should return nil when no prop is set' do
      SceneProp.new.behaviour.should be_nil
    end

    it 'should not be writable' do
      expect { subject.behaviour = 'another' }.to raise_error(NoMethodError)
    end
  end

  # HURDLES ---------------------------------------------------------------

  describe '#hurdles' do
    subject { SceneProp.new(prop: Prop.new(behaviour: 'hello')) }

    it 'should be able to set hurdles' do
      subject.hurdles = [1]
      subject.hurdles.should have(1).hurdle
    end

    it 'should return an empty array when no hurdles are set' do
      SceneProp.new.hurdles.should have(0).hurdles
    end
  end

  describe '#contatenated_hurdles' do
    subject { SceneProp.new(prop: Prop.new(behaviour: 'hello')) }

    it 'should return a string containing' do
      subject.hurdles = [0.1, 10.1, 20.2, 7.0, 1.0]
      subject.concatenated_hurdles.should eql('0.1, 10.1, 20.2, 7.0, 1.0')
    end
  end

  describe '#concatenated_hurdles=' do
    it 'should set nil when given an empty string' do
      prop = SceneProp.new(concatenated_hurdles: '')
      prop.hurdles.should be_nil
    end

    it 'should set nil when given nil' do
      prop = SceneProp.new(concatenated_hurdles: nil)
      prop.hurdles.should be_nil
    end

    it 'set values when given a comma separated string' do
      prop = SceneProp.new(concatenated_hurdles: '1,2,3')
      prop.hurdles.should eql([1.0, 2.0, 3.0])
    end

    it 'set values when given a comma-space separated string' do
      prop = SceneProp.new(concatenated_hurdles: '1, 2, 3')
      prop.hurdles.should eql([1.0, 2.0, 3.0])
    end
  end

  # QUERY EXTREMA ------------------------------------------------------------

  describe '#query_extrema' do
    context 'when set to nil' do
      subject { SceneProp.new(query_extrema: nil) }
      it { should have(:no).errors_on(:query_extrema) }
    end # when set to nil

    context 'when set to an empty hash' do
      subject { SceneProp.new(query_extrema: {}) }
      it { should have(:no).errors_on(:query_extrema) }
    end

    context 'when set to a hash containing a two-character country code' do
      subject { SceneProp.new(query_extrema: { 'nl' => [] }) }
      it { should have(:no).errors_on(:query_extrema) }
    end

    context 'when set to a hash containing a two-character country code' \
          'with data' do
      let(:data) { { 'query_key' => [ 0, 100 ] } }
      subject { SceneProp.new(query_extrema: { 'nl' => data }) }

      it { should have(:no).errors_on(:query_extrema) }
      its(:query_extrema) { should eql('nl' => { 'query_key' => [0, 100] }) }
    end
  end

end
