require 'spec_helper'

describe ScenariosController do
  render_views

  describe 'Creating a new session' do
    let(:scene) { create :scene }

    before(:each) do
      sign_in create(:user)
      post :create, scene_id: scene.id, id: 42, format: :json
    end

    it 'should respond with 201 Created' do
      response.status.should eql(201)
    end

    it 'should create a new Scenario' do
      Scenario.count.should eql(1)

      scenario = Scenario.first
      scenario.scene_id.should eql(scene.id)
      scenario.session_id.should eql(42)
    end
  end
end
