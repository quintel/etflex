require 'spec_helper'

describe 'GET /' do
  before  { get root_path }
  subject { response }

  it { status.should be(200) }
end
