require 'spec_helper'

describe Scene do
  it { should successfully_save }
  it { should successfully_save(:scene_with_key) }

  it { should embed_many(:scene_inputs) }
  it { should embed_many(:scene_props) }

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

  # PROP ---------------------------------------------------------------------

  describe '#prop' do
    before(:each) do
      @gauge = create :gauge
      @icon  = create :icon
      @scene = create :scene

      @scene_gauge = @scene.scene_props.create! prop: @gauge
      @scene_icon  = @scene.scene_props.create! prop: @icon
    end

    context 'when given a SceneProp for a Gauge' do
      subject { @scene.prop(@scene_gauge) }

      it 'should return a Gauge instance' do
        should be_kind_of(Props::Gauge)
      end

      it 'should return the correct Prop instance' do
        subject.id.should eql(@gauge.id)
      end

      it 'should return the same instance when invoked multiple times' do
        @scene.prop(@scene_gauge).should eql(subject)
        @scene.prop(@scene_icon).should eql(@icon)
      end
    end

    context 'when given a SceneProp for an Icon' do
      subject { @scene.prop(@scene_icon) }

      it 'should return an Icon instance' do
        should be_kind_of(Props::Icon)
      end

      it 'should return the correct Prop instance' do
        subject.id.should eql(@icon.id)
      end

      it 'should return the same instance when invoked multiple times' do
        @scene.prop(@scene_icon).should eql(subject)
        @scene.prop(@scene_gauge).should eql(@gauge)
      end
    end

    context "when given a SceneProp which isn't a scene_props member" do
      before(:each) do
        @graph = create :dual_bar_graph
        @scene_gauge = SceneProp.new(prop: @graph)
      end

      subject { @scene.prop(@scene_gauge) }

      it 'should return nil' do
        should be_nil
      end
    end

    context 'when given a blank SceneProp' do
      it 'should return nil' do
        @scene.prop(SceneProp.new).should be_nil
      end
    end

    context 'when given nil' do
      it 'should return nil' do
        @scene.prop(nil).should be_nil
      end
    end

    context 'when the Prop has been deleted' do
      it 'should return nil' do
        @icon.destroy
        @scene.prop(@scene_icon).should be_nil
      end
    end
  end # prop

end
