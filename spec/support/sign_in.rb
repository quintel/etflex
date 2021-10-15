module ETFlex::Spec
  module SignIn
    # Put helper methods you need to be available in all acceptance specs here.
    #
    # @param [String, User] user
    #   The user's login name (e-mail address). If a password (second param) is
    #   omitted, "login" should be a User instance.
    # @param [String] password
    #   The user's password.
    #
    def sign_in(user, password = nil)
      if user.is_a?(User)
        login    = user.email
        password = user.password unless password.present?
      else
        login    = user.to_s
      end

      visit '/hello'

      fill_in 'Email',    with: login
      fill_in 'Password', with: password

      click_button 'Sign in'

      # Sanity check.
      expect(page).to have_no_content('Sign in')
    end
  end # SignIn
end # ETFlex::Spec
