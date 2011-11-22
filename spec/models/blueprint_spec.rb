require 'spec_helper'

describe Blueprint do
  it { should validate_presence_of(:name) }
end
