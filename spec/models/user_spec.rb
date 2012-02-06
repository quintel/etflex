specrequire 'spec_helper'

describe User do
  it { should successfully_save }
  it { should successfully_save(:admin) }

  it { should allow_mass_assignment_of(:email) }
  it { should allow_mass_assignment_of(:password) }
  it { should allow_mass_assignment_of(:password_confirmation) }
  it { should allow_mass_assignment_of(:name) }

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

  # FIND OR CREATE WITH FACEBOOK ---------------------------------------------

  describe 'find_or_create_with_facebook!' do
    let(:attributes) do
      Hashie::Mash.new(
        info: {
          email: 'etflex@example.com',
          image: 'some-url.png',
          name:  'Person Name'
        },
        credentials: { token: 'abc' },
        uid: 'my-uid'
      )
    end

    describe 'when no matching user exists' do
      subject { User.find_or_create_with_facebook!(attributes) }

      it             { should be_kind_of(User) }
      it             { should be_persisted }
      its(:email)    { should eql('etflex@example.com') }
      its(:password) { should be_present }
      its(:origin)   { should eql('facebook') }
      its(:image)    { should eql('some-url.png') }
      its(:name)     { should eql('Person Name') }
      its(:uid)      { should eql('my-uid') }
      its(:token)    { should eql('abc') }
    end

    describe 'when the attributes hash is invalid' do
      it 'should raise an error' do
        attributes.info.email = nil

        expect { User.find_or_create_with_facebook!(attributes) }.to \
          raise_error(ActiveRecord::RecordInvalid)
      end
    end

    describe 'when a matching user already exists' do
      let(:user) { create :user, email: 'etflex@example.com' }
      before { user }

      it 'should return the user' do
        User.find_or_create_with_facebook!(attributes).should eql(user)
      end

      it 'should not create another user' do
        expect { User.find_or_create_with_facebook!(attributes) }.should_not \
          change { User.count }
      end
    end
  end # find or create with facebook

end
