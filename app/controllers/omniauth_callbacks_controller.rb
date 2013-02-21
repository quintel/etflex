class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def rtl
    @user = User.find_or_create_with_rtl!(request.env['omniauth.auth'])
    sign_in @user

    if referrer = request.env['omniauth.origin']
      # Let's change the scenario ownership. Ugly stuff
      session_id = referrer.split('/').last.to_i
      scenario = Scenario.find_by_session_id(session_id)
      if scenario
        scenario.user_id = @user.id
        scenario.save
      end
      redirect_to referrer
    else
      redirect_to '/scenes/1'
    end
  rescue ActiveRecord::RecordInvalid
    raise request.env['omniauth.auth']
  end

  def facebook
    @user = User.find_or_create_with_facebook!(request.env['omniauth.auth'])

    sign_in @user
    redirect_to root_path, notice: "succesfully signed in!"
  rescue ActiveRecord::RecordInvalid
    raise request.env['omniauth.auth']
  end

end
