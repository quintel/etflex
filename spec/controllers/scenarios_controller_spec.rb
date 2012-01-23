require 'spec_helper'

describe ScenariosController do
  render_views

  describe 'Creating a new session' do
    let(:scene) { create :scene }

    before(:each) do
      sign_in create(:user)
      put :update, scene_id: scene.id, id: 42, format: :json
    end

    it 'should respond with 200 OK' do
      response.status.should eql(200)
    end

    it 'should create a new Scenario' do
      Scenario.count.should eql(1)

      scenario = Scenario.first
      scenario.scene_id.should eql(scene.id)
      scenario.session_id.should eql(42)
    end
  end

  # --------------------------------------------------------------------------

  describe 'Updating an existing scenario' do
    let(:owner)    { create :user }
    let(:scene)    { create :scene }
    let(:scenario) { create :scenario, scene: scene, user: owner }

    context 'when the user owns the scenario' do
      before(:each) do
        sign_in owner

        put :update, scene_id: scene.id, id: scenario.session_id,
          scenario: { title: 'My new scenario title' }, format: :json
      end

      it 'should return 200 OK' do
        response.status.should eql(200)
      end

      it 'should apply the changes' do
        scenario.reload
        scenario.title.should eql('My new scenario title')
      end

      it 'should not create any additional scenarios' do
        Scenario.count.should eql(1)
      end
    end

    context 'when the user does not own the scenario' do
      before(:each) do
        sign_in create(:user)

        put :update, scene_id: scene.id, id: scenario.session_id,
          scenario: { title: 'My new scenario title' }, format: :json
      end

      it 'should return 403 Forbidden' do
        response.status.should eql(403)
      end

      it 'should not apply the changes' do
        scenario.reload
        scenario.title.should_not eql('My new scenario title')
      end

      it 'should not create any additional scenarios' do
        Scenario.count.should eql(1)
      end
    end
  end # Updating an existing scenario

end
