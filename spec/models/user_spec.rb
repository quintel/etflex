require 'spec_helper'

describe User do
  it { should successfully_save }
  it { should successfully_save(:admin) }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:name) }
  it { should allow_mass_assignment_of(:remember_me) }

  it { should allow_mass_assignment_of(:ip) }

  it { should_not allow_mass_assignment_of(:image) }
  it { should_not allow_mass_assignment_of(:origin) }
  it { should_not allow_mass_assignment_of(:uid) }
  it { should_not allow_mass_assignment_of(:token) }

  it { should_not allow_mass_assignment_of(:admin) }
  it { should_not allow_mass_assignment_of(:encrypted_password) }
  it { should_not allow_mass_assignment_of(:reset_password_token) }
  it { should_not allow_mass_assignment_of(:reset_password_sent_at) }
  it { should_not allow_mass_assignment_of(:remember_created_at) }

  describe 'admin' do
    it 'should default to false' do
      User.new.should_not be_admin
    end
  end # admin
end
