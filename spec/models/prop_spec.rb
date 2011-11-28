require 'spec_helper'

describe Prop do

  # NAME ---------------------------------------------------------------------

  describe 'name' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).with_maximum(100) }
  end

end
