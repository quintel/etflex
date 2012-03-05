require 'spec_helper'

describe Prop do

  it { should successfully_save }

  it { should validate_presence_of(:behaviour) }
  it { should ensure_length_of(:behaviour).is_at_least(1).is_at_most(100) }
  it { should allow_mass_assignment_of(:behaviour) }

  it { should validate_presence_of(:key) }
  it { should ensure_length_of(:key).is_at_least(1).is_at_most(100) }
  it { should allow_mass_assignment_of(:key) }

  # KEY ----------------------------------------------------------------------

  describe 'key' do
    context 'when blank but a behaviour is present' do
      it 'should use the client key' do
        Prop.new(behaviour: 'co2').key.should eql('co2')
      end

      it 'should underscore the client key' do
        prop = Prop.new(behaviour: 'co2-emissions')
        prop.key.should eql('co2_emissions')
      end
    end # when blank but a behaviour is present

    context 'when blank and no behaviour is present' do
      it 'should return nil' do
        Prop.new.key.should be_nil
      end
    end # when blank and no behaviour is present

    context 'when explicitly set' do
      it 'should use given key' do
        Prop.new(key: 'co3', behaviour: 'co2').key.should eql('co3')
      end
    end # when explicitly set
  end

end
