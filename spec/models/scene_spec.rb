require 'spec_helper'

describe Scene do
  it { should successfully_save }
  it { should successfully_save(:scene_with_key) }

  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:name_key) }

  it { should_not allow_mass_assignment_of(:scene_props) }
  it { should_not allow_mass_assignment_of(:props) }

  it { should_not allow_mass_assignment_of(:scene_inputs) }
  it { should_not allow_mass_assignment_of(:left_scene_inputs) }
  it { should_not allow_mass_assignment_of(:right_scene_inputs) }
  it { should_not allow_mass_assignment_of(:hidden_scene_inputs) }

  it { should_not allow_mass_assignment_of(:inputs) }
  it { should_not allow_mass_assignment_of(:left_inputs) }
  it { should_not allow_mass_assignment_of(:right_inputs) }
  it { should_not allow_mass_assignment_of(:hidden_inputs) }

  it { should_not allow_mass_assignment_of(:scenarios) }

  # RELATIONS ----------------------------------------------------------------

  it { should have_many(:scene_props) }
  it { should have_many(:scenarios) }

  it { should have_many(:scene_inputs) }
  it { should have_many(:left_scene_inputs) }
  it { should have_many(:right_scene_inputs) }

  it { should have_many(:inputs).through(:scene_inputs) }
  it { should have_many(:left_inputs).through(:left_scene_inputs) }
  it { should have_many(:right_inputs).through(:right_scene_inputs) }

  # NAME ---------------------------------------------------------------------

  describe 'name' do
    context 'when "name_key" is blank' do
      subject { Scene.new }

      it 'should not be blank' do
        subject.errors_on(:name).should include("can't be blank")
      end

      it 'should be no longer than 100 characters' do
        subject.name = ( 'x' * 101 )
        subject.errors_on(:name).should include(
          "is too long (maximum is 100 characters)")
      end
    end # when "name_key" is blank

    context 'when "name_key" is present' do
      subject { Scene.new(name_key: 'key') }

      it 'should permit blank values' do
        subject.should have(:no).errors_on(:key)
      end

      it 'should be no longer than 100 characters' do
        subject.name = ( 'x' * 101 )
        subject.errors_on(:name).should include(
          "is too long (maximum is 100 characters)")
      end
    end # when "name_key" is present
  end # name

end
