require 'spec_helper'

describe 'Scenes' do

  # --------------------------------------------------------------------------

  specify 'Viewing the ETlite scene', js: true do

    # Set up records.

    input_one = create :input, key: 'transport_cars_electric_share'
    input_two = create :input, key: 'number_of_coal_conventional'

    scene = create :scene

    scene.scene_inputs.create! input: input_one, location: 'left'
    scene.scene_inputs.create! input: input_two, location: 'right'

    # Finally...!

    visit "/scenes/#{ scene.id }"

    # Low-energy lighting.

    page.should have_css('.label', text: 'Electric cars')

    # Test that the Low-energy lighting range value is 0
    #
    # TODO Find a nice way to extract this into a method. Perhaps an
    #      RSpec matcher?
    #
    #      page.should have_range('Electric cars', value: 0)
    #
    page.all('.range').each do |range|
      if range.has_css?('.label', text: 'Electric cars')
        range.should have_css('.output', text: '0')
      end
    end

    # Electric cars.

    page.should have_css('.label', text: 'Coal-fired power plants')

    page.all('.range').each do |range|
      if range.has_css?('.label', text: 'Coal-fired power plants')
        range.should have_css('.output', text: '0')
      end
    end

  end

  # --------------------------------------------------------------------------

  context 'retrieving a list of scenes', api: true do
    let(:json) { JSON.parse page.source }

    before { @scene = create :scene, name_key: 'test' }
    before { visit '/scenes' }

    subject { json }

    it { page.status_code.should eql(200) }
    it { should be_kind_of(Hash) }
    it { should have_key('scenes') }

    context 'a Scene in the collection' do
      subject { json['scenes'].first }

      it { should have_key('id')       }
      it { should have_key('href')     }
      it { should have_key('name')     }
      it { should have_key('name_key') }
    end
  end

  # --------------------------------------------------------------------------

  context 'retrieving a scene', api: true do
    let(:scene)  {   create(:scene)                   }
    let(:inputs) { [ create(:input), create(:input) ] }
    let(:props)  { [ create(:prop),  create(:prop)  ] }

    before do
      # Create two inputs, with two scene inputs; two props, and two
      # scene props.

      scene.scene_inputs.create! input: inputs[0], location: 'left'
      scene.scene_inputs.create! input: inputs[1], location: 'right'

      #scene.scene_props.build prop: props[0], location: 'center'
      #scene.scene_props.build prop: props[1], location: 'bottom'
    end

    before  { visit "/scenes/#{scene.id}" }
    subject { JSON.parse page.source }

    it { page.status_code.should eql(200) }

    it { should have_key('id')        }
    it { should have_key('name')      }
    it { should have_key('inputs')    }
    it { should have_key('props')     }
    it { should have_key('centerVis') }
    it { should have_key('mainVis')   }

    its(['inputs']) { should have(2).members }
    #its(['props'])  { should have(2).members }

    context 'inputs' do
      context 'the first input' do
        let(:input_json) { subject['inputs'].first }
        let(:input)      { inputs.first }

        it 'should be present' do
          input_json.should_not be_nil
        end

        it 'should set the remoteId' do
          input_json['remoteId'].should eql(input.remote_id)
        end

        it 'should include the location' do
          input_json['location'].should eql('left')
        end

        it 'should include the position' do
          input_json['position'].should eql(1)
        end
      end # the first input

      context 'the second input' do
        let(:input_json) { subject['inputs'].last }
        let(:input)      { inputs.last }

        it 'should be present' do
          input_json.should_not be_nil
        end

        it 'should set the remoteId' do
          input_json['remoteId'].should eql(input.remote_id)
        end

        it 'should include the location' do
          input_json['location'].should eql('right')
        end

        it 'should include the position' do
          input_json['position'].should eql(1)
        end
      end # the first input
    end # inputs
  end

  # --------------------------------------------------------------------------

end
