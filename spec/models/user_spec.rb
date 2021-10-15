require 'rails_helper'

describe User do
  it { should successfully_save }
  it { should successfully_save(:admin) }

  describe 'admin' do
    it 'should default to false' do
      User.new.should_not be_admin
    end
  end # admin
end
