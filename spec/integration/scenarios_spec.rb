require 'spec_helper'

feature 'Viewing scenarios', js: true do
  let(:scene) { create :scene_with_inputs }
  let(:owner) { create :user }

  def create_scenario(scene_id, user = nil)
    sign_in(user) if user
    visit "/scenes/#{ scene_id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    visit '/goodbye' if user

    Scenario.last
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest, creating a new scenario' do
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }"

    # Wait until the page scene has loaded.
    page.should have_css('#left-inputs')

    # Should have saved a new guest scenario.
    Scenario.count.should eql(num_scenarios + 1)

    scenario = Scenario.first

    scenario.guest_uid.should be_present
    scenario.user_id.should   be_blank

    # TODO Once we can test slider movement assert that the guest changing
    #      the inputs saves the changes to the scenario.
  end

  # --------------------------------------------------------------------------

  scenario "As a guest, viewing one's own session" do
    scenario      = create_scenario(scene.id, owner)
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the page scene has loaded.
    page.should have_css('#left-inputs')

    # Should not have saved a new scenario (it already exists).
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the guest can
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest, viewing a scenario belonging to another guest' do
    pending 'Awaiting guest scenario persistence'
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest, viewing a scenario belonging to a registered user' do
    scenario      = create_scenario(scene.id, owner)
    num_scenarios = Scenario.count

    scenario.guest_uid = nil
    scenario.user      = owner
    scenario.save!

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the page scene has loaded.
    page.should have_css('#left-inputs')

    # Should not have saved a new scenario.
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the guest cannot
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, creating a new scenario' do
    num_scenarios = Scenario.count

    sign_in owner

    visit "/scenes/#{ scene.id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Should have saved a new scenario.
    Scenario.count.should eql(num_scenarios + 1)

    # TODO Once we can test slider movement assert that the changes are also
    #      saved to the ETFlex scenario.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, viewing a scenario I own' do
    scenario      = create_scenario(scene.id, owner)
    num_scenarios = Scenario.count

    sign_in owner

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Should not have saved a new scenario (one already exists).
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the changes are also
    #      saved to the ETFlex scenario.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, viewing a scenario owned by another user' do
    scenario      = create_scenario(scene.id, owner)
    num_scenarios = Scenario.count

    sign_in create(:user)

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Should have not have saved a new scenario.
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the user cannot
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, viewing a scenario owned by a guest' do
    pending 'Awaiting guest scenario persistence'
  end
end

# ----------------------------------------------------------------------------

describe 'Scenarios' do
  context 'Retrieving a scenario', api: true do
    let(:scene)    { create(:detailed_scene) }

    let(:scenario) { create(:scenario, scene: scene,
                       input_values:  { '1' => '2' },
                       query_results: { '3' => '4' }) }

    let(:json)     { JSON.parse page.source }

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
      it { should include(queryResults: scenario.query_results) }
      it { should include(inputValues: scenario.input_values.stringify_keys) }
    end

  end # Retrieving a scenario (api)
end # Scenarios
