require 'spec_helper'

describe 'Scenes' do

  # --------------------------------------------------------------------------

  specify 'Viewing the ETlite scene', js: true do

    scene = create :scene_with_inputs, name: 'Balancing Supply and Demand'

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

        # No info; a (?) should not be present.
        range.should_not have_css('.help')
      end
    end

    # Electric cars.

    page.should have_css('.label', text: 'Coal-fired power plants')

    page.all('.range').each do |range|
      if range.has_css?('.label', text: 'Coal-fired power plants')
        range.should have_css('.output', text: '0')

        # Has info; a (?) should be present.
        range.should have_css('.help')
      end
    end

  end

  # --------------------------------------------------------------------------

  context 'Retrieving a list of scenes', api: true do
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

      it { should_not have_key('info') }
    end
  end

  # --------------------------------------------------------------------------

  context 'Retrieving a scene', api: true do
    let(:scene)  { create(:detailed_scene) }
    let(:json)   { JSON.parse page.source  }

    before do
      # Visit the scene page to fetch JSON.
      visit "/scenes/#{ scene.id }"
    end

    it { page.status_code.should eql(200) }

    it_should_behave_like 'scene JSON' do
      let(:scene_json) { json }
    end
  end

  # --------------------------------------------------------------------------

end
