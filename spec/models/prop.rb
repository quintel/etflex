require 'spec_helper'

describe Prop do

  it { should validate_presence_of(:client_key) }
  it { should ensure_length_of(:client_key).is_at_least(1).is_at_most(100) }

end
