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
    let(:scene) { create :scene }

    before  { visit "/scenes/#{scene.id}" }
    subject { JSON.parse page.source }

    it { page.status_code.should eql(200) }

    it { should have_key('id')        }
    it { should have_key('name')      }
    it { should have_key('inputs')    }
    it { should have_key('centerVis') }
    it { should have_key('mainVis')   }
  end

  # --------------------------------------------------------------------------

end
