require 'spec_helper'

# Shared Examples ------------------------------------------------------------

shared_examples_for 'an embedded scene input' do
  before { subject and subject.symbolize_keys!    }

  it { should_not be_nil                          }

  it { should include(key:       input.key)       }
  it { should include(start:     input.start)     }
  it { should include(min:       input.min)       }
  it { should include(max:       input.max)       }
  it { should include(step:      input.step)      }
  it { should include(unit:      input.unit)      }
  it { should include(position:  input.position)  }
  it { should include(location:  input.location)  }
  it { should include(remoteId:  input.remote_id) }
end

shared_examples_for 'an embedded scene prop' do
  before { subject and subject.symbolize_keys!    }

  it { should_not be_nil                          }

  it { should include(key:       prop.key)        }
  it { should include(behaviour: prop.behaviour) }
  it { should include(position:  prop.position)   }
  it { should include(location:  prop.location)   }
end

# Scene Examples -------------------------------------------------------------

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
    end
  end

  # --------------------------------------------------------------------------

  context 'Retrieving a scene', api: true do
    let(:scene)  { create(:scene)         }
    let(:json)   { JSON.parse page.source }

    before do
      # Create two inputs, with two scene inputs; two props, and two
      # scene props.
      inputs = [ create(:input), create(:input) ]
      props  = [ create(:prop),  create(:prop)  ]

      scene.scene_inputs.create! input: inputs[0], location: 'left'
      scene.scene_inputs.create! input: inputs[1], location: 'right'

      scene.scene_props.create!  prop: props[0],   location: 'center'
      scene.scene_props.create!  prop: props[1],   location: 'bottom'

      # Visit the scene page to fetch JSON.
      visit "/scenes/#{ scene.id }"
    end

    it { page.status_code.should eql(200) }

    context 'JSON' do
      subject { json }

      it { should have_key('id')        }
      it { should have_key('name')      }
      it { should have_key('inputs')    }
      it { should have_key('props')     }

      its(['inputs']) { should have(2).members }
      its(['props'])  { should have(2).members }
    end

    context 'inputs' do
      context 'the first input' do
        subject     { json['inputs'].first }
        let(:input) { scene.scene_inputs.first }

        it_should_behave_like 'an embedded scene input'
      end # the first input

      context 'the second input' do
        subject     { json['inputs'].last }
        let(:input) { scene.scene_inputs.last }

        it_should_behave_like 'an embedded scene input'
      end # the second input
    end # inputs

    context 'props' do
      context 'the first prop' do
        subject    { json['props'].first }
        let(:prop) { scene.scene_props.first }

        it_should_behave_like 'an embedded scene prop'
      end # the first prop

      context 'the second prop' do
        subject    { json['props'].last }
        let(:prop) { scene.scene_props.last }

        it_should_behave_like 'an embedded scene prop'
      end # the second prop
    end # props
  end

  # --------------------------------------------------------------------------

end
