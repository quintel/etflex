require 'spec_helper'

describe Input do

  it { should be_mongoid_document }
  it('should save the factory') { create(:input) }

  # KEY ----------------------------------------------------------------------

  describe 'key' do
    it { should validate_presence_of(:key) }
    it { should validate_uniqueness_of(:key) }
    it { should have_index_for(:key).with_options(:unique => true) }
  end

  # REMOTE ID ----------------------------------------------------------------

  describe 'remote ID' do
    it { should validate_presence_of(:remote_id) }
    it { should validate_uniqueness_of(:remote_id) }
    it { should have_index_for(:remote_id).with_options(unique: true) }
  end

  # MINIMUM VALUE ------------------------------------------------------------

  describe 'minimum value' do
    it { should validate_presence_of(:min) }
    it { should validate_numericality_of(:min) }
  end

  # MAXIMUM VALUE ------------------------------------------------------------

  describe 'maximum value' do
    it { should validate_presence_of(:max) }
    it { should validate_numericality_of(:max) }

    it 'should not be less than the minimum value' do
      input  = Input.new min: 5, max: 4
      errors = input.errors_on(:max)

      errors.should \
        include('The maximum value must be equal or greater than the ' \
                'minimum value')
    end

    it 'should skip maximum >= minimum validation when minimum is nil' do
      input  = Input.new min: nil
      errors = input.errors_on(:max)

      errors.should_not \
        include('The maximum value must be equal or greater than the ' \
                'minimum value')
    end

    it 'should skip maximum >= minimum validation when maximum is nil' do
      input = Input.new max: nil
      errors = input.errors_on(:max)

      errors.should_not \
        include('The maximum value must be equal or greater than the ' \
                'minimum value')
    end
  end

  # STEP VALUE ---------------------------------------------------------------

  describe 'step value' do
    it { should validate_presence_of(:step) }
    it { should validate_numericality_of(:step) }
  end

  # START VALUE --------------------------------------------------------------

  describe 'start value' do
    it { should validate_presence_of(:start) }
    it { should validate_numericality_of(:start) }

    it 'should default to the minimum value' do
      Input.new(min: 50.0).start.should eql(50.0)
    end
  end

end
