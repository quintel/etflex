require 'spec_helper'

describe Output do

  # KEY ----------------------------------------------------------------------

  it { should validate_presence_of(:key) }
  xit { should validate_uniqueness_of(:key) }

  # TYPE NAME ----------------------------------------------------------------

  it { should validate_presence_of(:type_name) }
  it 'should validate that type name is a valid type'

end
