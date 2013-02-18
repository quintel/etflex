class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def rtl
    @data = request.env['omniauth.auth']
    @email = 'foobar@foo.com'
    render 'devise/rtl'
    # render :text => request.env['omniauth.auth'].to_yaml
  #   @user = User.find_or_create_with_rtl!(request.env['omniauth.auth'])

  #   sign_in @user
  #   redirect_to root_path, notice: "succesfully signed in!"
  # rescue ActiveRecord::RecordInvalid
  #   raise request.env['omniauth.auth']
  end

  def facebook
    @user = User.find_or_create_with_facebook!(request.env['omniauth.auth'])

    sign_in @user
    redirect_to root_path, notice: "succesfully signed in!"
  rescue ActiveRecord::RecordInvalid
    raise request.env['omniauth.auth']
  end

end
