# Shared examples which test common functionality in Backstage controllers
# (such as asserting that ordinary users cannot access them, etc).
shared_examples_for 'a backstage controller' do
  before(:each) { visit '/goodbye' }

  it 'should deny access to guests and require signing in' do
    visit path
    page.should have_css('h1', text: 'Sign in')
  end

  it 'should deny access to ordinary users with a 404' do
    sign_in create(:user)

    visit path
    page.should have_content("The page you were looking for doesn't exist")
  end

  it 'should permit access to administrators' do
    sign_in create(:admin)

    visit path
    page.should_not have_css('h1', text: 'Sign in')
  end
end
