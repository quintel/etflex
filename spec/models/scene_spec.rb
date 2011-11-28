require 'spec_helper'

describe Scene do

  it { should embed_many(:scene_inputs) }

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
