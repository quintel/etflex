require 'spec_helper'

describe 'Scenarios' do

  # --------------------------------------------------------------------------

  context 'Retrieving a scenario', api: true do
    let(:scene)    { create(:scene)                  }
    let(:scenario) { create(:scenario, scene: scene) }
    let(:json)     { JSON.parse page.source          }

    before do
      # Create two inputs, with two scene inputs; two props, and two
      # scene props.
      inputs = [ create(:input), create(:input) ]
      props  = [ create(:prop),  create(:prop)  ]

      scene.scene_inputs.create!(input: inputs[0], location: 'left')
      scene.scene_inputs.create!(
        input: inputs[1], location: 'right', information_en: 'English')

      scene.scene_props.create! prop: props[0], location: 'center'
      scene.scene_props.create! prop: props[1], location: 'bottom',
        hurdles: [1, 2, 3]

      # Visit the scene page to fetch JSON.
      visit "/scenes/#{ scene.id }/scenarios/#{ scenario.id }"
    end

    it { page.status_code.should eql(200) }

    it_should_behave_like 'scene JSON' do
      let(:scene_json) { json['scene'] }
    end

    context 'JSON' do
      subject { json.symbolize_keys }

      it { should include(id: scenario.id) }
    end

  end # Retrieving a scenario (api)

end # Scenarios
