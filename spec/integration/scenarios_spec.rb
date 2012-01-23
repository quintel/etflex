require 'spec_helper'

describe 'Scenarios' do

  # --------------------------------------------------------------------------

  context 'Retrieving a scenario', api: true do
    let(:scene)    { create(:detailed_scene)         }
    let(:scenario) { create(:scenario, scene: scene) }
    let(:json)     { JSON.parse page.source          }

    before do
      # Visit the scene page to fetch JSON.
      visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"
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
