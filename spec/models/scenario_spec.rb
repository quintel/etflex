require 'spec_helper'

describe Scenario do
  it { should successfully_save }

  # RELATIONS ----------------------------------------------------------------

  it { should belong_to(:user) }
  it { should belong_to(:scene) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:scene_id) }
  it { should validate_presence_of(:session_id) }

  it {
    create :scenario
    should validate_uniqueness_of(:session_id) }

end
