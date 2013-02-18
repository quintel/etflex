class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def rtl
    @email = request.env['omniauth.auth']['info']['email'] rescue nil
    session[:guest_email] = @email
    #redirect_to '/scenes/2'
    render :text => request.env['omniauth.auth'].to_yaml
  end

  def facebook
    @user = User.find_or_create_with_facebook!(request.env['omniauth.auth'])

    sign_in @user
    redirect_to root_path, notice: "succesfully signed in!"
  rescue ActiveRecord::RecordInvalid
    raise request.env['omniauth.auth']
  end

end
