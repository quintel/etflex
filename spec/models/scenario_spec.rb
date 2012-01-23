require 'spec_helper'

describe Scenario do
  it { should successfully_save }

  # ATTRIBUTES --------------------------------------------------------------

  it { should_not allow_mass_assignment_of(:user) }
  it { should_not allow_mass_assignment_of(:user_id) }

  it { should_not allow_mass_assignment_of(:scene) }
  it { should_not allow_mass_assignment_of(:scene_id) }

  it { should_not allow_mass_assignment_of(:session_id) }

  it { should allow_mass_assignment_of(:title) }
  it { should allow_mass_assignment_of(:user_values) }

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
