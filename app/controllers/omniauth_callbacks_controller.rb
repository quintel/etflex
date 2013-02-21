class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def rtl
    @user = User.find_or_create_with_rtl!(request.env['omniauth.auth'])
    sign_in @user

    redirect_to '/scenes/1'
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
