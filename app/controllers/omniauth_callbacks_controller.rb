class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def rtl
    # @email = request.env['omniauth.auth']['info']['email'] rescue nil
    # session[:guest_email] = @email
    # session[:guest_name]  = @email.split('@').first # Any better idea?
    # redirect_to '/scenes/2'
    #
    @user = User.find_or_create_with_rtl!(request.env['omniauth.auth'])
    sign_in @user
    redirect_to root_path, notice: "succesfully signed in!"
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
