require 'spec_helper'

describe Input do

  it { should successfully_save }

  # KEY ----------------------------------------------------------------------

  describe 'key' do
    it { should validate_presence_of(:key) }
    it { create(:input) ; should validate_uniqueness_of(:key) }
    it { should allow_mass_assignment_of(:key) }
  end

  # IDENTITY FIELD -----------------------------------------------------------

  describe 'identity field' do
    it { should validate_presence_of(:remote_id) }
    it { create(:input) ; should validate_uniqueness_of(:remote_id) }
    it { should allow_mass_assignment_of(:remote_id) }
  end

  # UNIT ---------------------------------------------------------------------

  describe '#unit' do
    it { should_not validate_presence_of(:unit) }
    it { should allow_mass_assignment_of(:unit) }
  end

  # MINIMUM VALUE ------------------------------------------------------------

  describe 'minimum value' do
    it { should validate_presence_of(:min) }
    it { should validate_numericality_of(:min) }
    it { should allow_mass_assignment_of(:min) }
  end

  # MAXIMUM VALUE ------------------------------------------------------------

  describe 'maximum value' do
    it { should validate_presence_of(:max) }
    it { should validate_numericality_of(:max) }
    it { should allow_mass_assignment_of(:max) }

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
    it { should allow_mass_assignment_of(:step) }
  end

  # START VALUE --------------------------------------------------------------

  describe 'start value' do
    it { should validate_presence_of(:start) }
    it { should validate_numericality_of(:start) }
    it { should allow_mass_assignment_of(:start) }

    it 'should default to the minimum value' do
      Input.new(min: 50.0).start.should eql(50.0)
    end
  end

  # GROUP --------------------------------------------------------------------

  describe 'group' do
    it { should_not validate_presence_of(:group) }
    it { should allow_mass_assignment_of(:group) }
    it { should allow_value('name').for(:group) }
    it { should allow_value(nil).for(:group) }
    it { should ensure_length_of(:group).is_at_most(50) }
  end

  # SIBLINGS -----------------------------------------------------------------

  describe 'siblings' do
    let!(:focus)     { create :input, group: 'my-group' }
    let!(:sibling_1) { create :input, group: 'my-group' }
    let!(:sibling_2) { create :input, group: 'my-group' }
    let!(:cousin_1)  { create :input, group: 'another-group' }

    describe 'when the given input belongs to no group' do
      it 'should return an empty array' do
        Input.siblings(create :input).should be_empty
      end
    end

    describe 'when given a single, grouped input with two siblings' do
      subject { Input.siblings focus }

      it 'should contain the siblings' do
        should have(2).members
      end

      it 'should contain the first sibling' do
        should include(sibling_1)
      end

      it 'should contain the second sibling' do
        should include(sibling_2)
      end

      it 'should not include the focused input' do
        should_not include(focus)
      end
    end

    describe 'when given multiple, grouped inputs with three siblings' do
      let!(:focus_2) { create :input, group: 'another-group' }

      subject { Input.siblings [ focus, focus_2 ] }

      it 'should contain the siblings' do
        should have(3).members
      end

      it 'should contain the first sibling' do
        should include(sibling_1)
      end

      it 'should contain the second sibling' do
        should include(sibling_2)
      end

      it 'should contain the third sibling' do
        should include(cousin_1)
      end

      it 'should not include the focused inputs' do
        should_not include(focus)
        should_not include(focus_2)
      end
    end

    describe 'when given multiple, grouped scene inputs with three siblings' do
      let!(:focus_2) { create :input, group: 'another-group' }

      subject { Input.siblings [
        SceneInput.new { |si| si.input = focus },
        SceneInput.new { |si| si.input = focus_2} ] }

      it 'should contain the siblings' do
        should have(3).members
      end

      it 'should contain the first sibling' do
        should include(sibling_1)
      end

      it 'should contain the second sibling' do
        should include(sibling_2)
      end

      it 'should contain the third sibling' do
        should include(cousin_1)
      end

      it 'should not include the focused inputs' do
        should_not include(focus)
        should_not include(focus_2)
      end
    end
  end # siblings

  # DEPENDENT SIBLINGS -------------------------------------------------------

  describe 'dependent siblings' do
    let!(:focus_1)   { create :input, group: 'my-group' }
    let!(:sibling_1) { create :input, group: 'my-group' }
    let!(:cousin_1)  { create :input, group: 'another-group' }

    describe 'when the given input belongs to no group' do
      it 'should return an empty array' do
        Input.siblings(create :input).should be_empty
      end
    end

    describe 'when given a single, grouped input with two siblings' do
      let!(:sibling_2) { create :input, group: 'my-group' }

      subject { Input.siblings focus_1 }

      it 'should contain the siblings' do
        should have(2).members
      end

      it 'should contain the first sibling' do
        should include(sibling_1)
      end

      it 'should contain the second sibling' do
        should include(sibling_2)
      end

      it 'should not contain the focused input' do
        should_not include(focus_1)
      end
    end

    describe 'when given two grouped inputs with one sibling' do
      let!(:focus_2) { create :input, group: 'my-group' }

      subject { Input.dependent_siblings([ focus_1, focus_2 ]) }

      it 'should return no inputs' do
        should have(:no).members
      end

      it 'should not contain the focused inputs' do
        should_not include(focus_1)
        should_not include(focus_2)
      end

      it 'should not contain the unspecified sibling' do
        should_not include(sibling_1)
      end
    end # when given two grouped inputs with one sibling

    describe 'when given multiple grouped inputs' do
      let!(:cousin_2) { create :input, group: 'another-group' }
      let!(:focus_2)  { create :input, group: 'my-group' }

      subject { Input.dependent_siblings [ focus_1, focus_2, cousin_1 ] }

      it 'should contain one input' do
        should have(1).member
      end

      it 'should contain the cousin sibling' do
        should include(cousin_2)
      end

      it 'should not contain the focus siblings' do
        should_not include(focus_1)
        should_not include(focus_2)
        should_not include(sibling_1)
      end
    end
  end # dependent siblings

end
