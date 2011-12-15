require 'spec_helper'

describe SceneProp do

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

  # CLIENT KEY ---------------------------------------------------------------

  describe '#client_key' do
    subject { SceneProp.new(prop: Prop.new(client_key: 'hello')) }

    it 'should be delegated to the prop' do
      subject.client_key.should eql('hello')
    end

    it 'should return nil when no prop is set' do
      SceneProp.new.client_key.should be_nil
    end

    it 'should not be writable' do
      expect { subject.client_key = 'another' }.to raise_error(NoMethodError)
    end
  end

end
