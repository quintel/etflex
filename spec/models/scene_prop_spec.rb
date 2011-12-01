require 'spec_helper'

describe SceneProp do

  it { should be_embedded_in(:scene) }
  it { should belong_to(:prop).of_type(Props::Base) }

  # PROP ID ------------------------------------------------------------------

  describe 'prop ID' do
    it { should validate_presence_of(:prop_id) }
  end

  # PROP ---------------------------------------------------------------------

  describe '#prop' do
    let(:prop) { create :gauge }
    subject { SceneProp.new prop: prop }

    context 'when a #scene is set' do
      let(:scene) { build(:scene).tap { |s| s.scene_props.push(subject) } }

      it 'should call Scene#prop' do
        scene.should_receive(:prop).with(subject).once
        subject.prop
      end

      it 'should return the correct prop' do
        subject.prop.should eql(prop)
      end

      it 'should not call Scene#Prop if reloading' do
        scene.should_not_receive(:prop)
        subject.prop(:reload)
      end

      context 'and no prop is set' do
        before(:each) { subject.prop = nil }

        it 'should not call Scene#prop' do
          scene.should_not_receive(:prop)
        end

        it 'should return nil' do
          subject.prop.should be_nil
        end
      end
    end # when a #scene is set

    context 'when no #scene is set' do
      it 'should return the correct prop' do
        subject.prop.should eql(prop)
      end
    end # when no #scene is set
  end # #prop

end
