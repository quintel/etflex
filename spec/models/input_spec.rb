require 'spec_helper'

describe Input do

  # KEY ----------------------------------------------------------------------

  it { should validate_presence_of(:key) }
  xit { should validate_uniqueness_of(:key) }
  it { should allow_mass_assignment_of(:key) }

  # REMOTE ID ----------------------------------------------------------------

  it { should validate_presence_of(:remote_id) }
  xit { should validate_uniqueness_of(:remote_id) }
  it { should allow_mass_assignment_of(:remote_id) }

  # MINIMUM VALUE ------------------------------------------------------------

  it { should validate_presence_of(:min) }
  it { should validate_numericality_of(:min) }
  it { should allow_mass_assignment_of(:min) }

  # MAXIMUM VALUE ------------------------------------------------------------

  it { should validate_presence_of(:max) }
  it { should validate_numericality_of(:max) }
  it { should allow_mass_assignment_of(:max) }

  # START VALUE --------------------------------------------------------------

  it { should validate_presence_of(:start) }
  it { should validate_numericality_of(:start) }
  it { should allow_mass_assignment_of(:start) }

  # STEP VALUE ---------------------------------------------------------------

  it { should validate_presence_of(:step) }
  it { should validate_numericality_of(:step) }
  it { should allow_mass_assignment_of(:step) }

end
