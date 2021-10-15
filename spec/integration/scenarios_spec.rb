require 'rails_helper'

# We need type to use allow  sign_in
feature 'Viewing scenarios', js: true, type: :request do
  include ETFlex::Spec::SignIn

  let(:scene) { create :detailed_scene, name: 'Balancing Supply and Demand' }
  let(:owner) { create :user }

  def create_scenario(scene_id, user = nil)
    sign_in(user) if user

    # Remove any existing scenarios.
    Scenario.delete_all

    visit "/scenes/#{ scene_id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    wait_for_scenario { |_| }

    visit '/goodbye' if user

    Scenario.first
  end

  def clear_scenarios_except(scenario)
    Scenario.all.each { |s| s.destroy unless s.id == scenario.id }
  end

  def wait_for_scenario
    scenario = nil

    Timeout.timeout(1) do
      until (scenario = Scenario.last)
      end

      yield scenario
    end

    raise 'Expected saved scenario to appear' unless scenario
  end

  # make sure the scene exists before starting.
  background { scene }

  # --------------------------------------------------------------------------

  scenario 'As a guest, creating a new scenario' do
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }"

    # Wait until the page scene has loaded.
    find('#left-inputs')

    wait_for_scenario do |scenario|
      scenario.guest_uid.should be_present
      scenario.user_id.should   be_blank
    end
  end

  # --------------------------------------------------------------------------

  scenario "As a guest, viewing one's own session" do
    scenario      = create_scenario(scene.id)
    num_scenarios = Scenario.count

    scenario.guest_uid.should be_present # Sanity check.

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the page scene has loaded.
    page.should have_css('#left-inputs')

    # Wait for JS to finish.
    sleep 0.2

    # Should not have saved a new scenario (it already exists).
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the guest can
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest, viewing a scenario belonging to another guest' do
    scenario      = create_scenario(scene.id)
    num_scenarios = Scenario.count

    scenario.guest_uid.should be_present # Sanity check.

    scenario.guest_uid = SecureRandom.uuid
    scenario.save!

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the page scene has loaded.
    page.should have_css('#left-inputs')

    # Wait for JS to finish.
    sleep 0.2

    # Should not have saved a new scenario (it already exists).
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the guest cannot
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'As a guest, viewing a scenario belonging to a registered user' do
    scenario      = create_scenario(scene.id, owner)
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the page scene has loaded.
    page.should have_css('#left-inputs')

    # Wait for JS to finish.
    sleep 0.2

    # Should not have saved a new scenario.
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the guest cannot
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, creating a new scenario' do
    sign_in owner
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Wait for JS to finish.
    sleep 0.2

    # Should have saved a new scenario.
    Scenario.count.should eql(num_scenarios + 1)

    Scenario.last.user.should eql(owner) # Sanity check.

    # TODO Once we can test slider movement assert that the changes are also
    #      saved to the ETFlex scenario.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, viewing a scenario I own' do
    scenario = create_scenario(scene.id, owner)
    scenario.user.should eql(owner) # Sanity check.

    sign_in owner

    clear_scenarios_except scenario
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Wait for JS to finish.
    sleep 0.2

    # Should not have saved a new scenario (one already exists).
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the changes are also
    #      saved to the ETFlex scenario.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, viewing a scenario owned by another user' do
    scenario = create_scenario(scene.id, owner)
    scenario.user.should eql(owner) # Sanity check.

    sign_in create(:user)

    clear_scenarios_except scenario
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Wait for JS to finish.
    sleep 0.2

    # Should have not have saved a new scenario.
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the user cannot
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'As a user, viewing a scenario owned by a guest' do
    scenario = create_scenario(scene.id)
    scenario.guest_uid.should be_present # Sanity check.

    sign_in owner

    clear_scenarios_except scenario
    num_scenarios = Scenario.count

    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    # Wait for JS to finish.
    sleep 0.2

    # Should have not have saved a new scenario.
    Scenario.count.should eql(num_scenarios)

    # TODO Once we can test slider movement assert that the user cannot
    #      change the value of an input.
  end

  # --------------------------------------------------------------------------

  scenario 'Visiting a scenario from another QI app' do
    # Emulate a scenario which exists on another app by creating one on
    # ETengine, then removing the scenario record on ETflex.
    visit "/scenes/#{ scene.id }"

    # Wait until the scene has loaded.
    page.should have_css('#left-inputs')

    sleep 0.2

    scenario = Scenario.last
    scenario.destroy

    # Visiting the scenario should *not* fetch data from ETengine, but
    # instead 404.
    visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"

    sleep 0.2

    expect(page).to have_content("The page you were looking for doesn't exist")
  end

end

# ----------------------------------------------------------------------------

describe 'Scenarios' do

  # Capybara::Selenium has no status_code support
  def have_status_code_ok
    have_no_content("The page you were looking for doesn't exist") && # 404
      have_no_content('The change you wanted was rejected') && # 422
      have_no_content("We're sorry, but something went wrong") # 500
  end

  context 'Retrieving a scenario', api: true do
    let(:scene)    { create(:detailed_scene) }

    let(:scenario) { create(:scenario, scene: scene,
                       guest_name: 'A Person',
                       input_values:  { '1' => '2' },
                       query_results: { '3' => { 'present' => '5',
                                                 'future'  => '4' }}) }

    let(:json)     { JSON.parse page.source }

    before do
      # Visit the scene page to fetch JSON.
      visit "/scenes/#{ scene.id }/with/#{ scenario.session_id }"
    end

    it 'is succesful' do
      expect(page).to have_status_code_ok
    end

    it_should_behave_like 'scene JSON' do
      let(:scene_json) { json['scene'] }
    end

    context 'JSON' do
      subject { json.symbolize_keys }

      it { should include(guestName: 'A Person') }
      it { should include(sessionId: scenario.session_id) }
      it { should include(queryResults: scenario.query_results) }
      it { should include(inputValues: scenario.input_values.stringify_keys) }
    end

  end # Retrieving a scenario (api)

  describe 'summaries', api: true do
    let!(:summary) do
      create(:guest_scenario).tap { |s| s.touch }
    end

    context 'with an integer-like :days param' do
      before { visit "/scenes/#{ Scene.last.id }/scenarios/since/6.json" }

      it 'should be 200' do
        page.status_code.should eql(200)
      end

      it 'should include the summary' do
        json = JSON.parse(page.source)

        json.should have(1).member
        json[0].should include('session_id' => summary.session_id)
      end
    end # with an integer-like :days param

    context 'with a non-integer :days param' do
      before { visit "/scenes/#{ Scene.last.id }/scenarios/since/2012-03-26" }

      it 'should be 400' do
        page.status_code.should eql(400)
      end
    end # with a non-integer :days param
  end # summaries

end # Scenarios
