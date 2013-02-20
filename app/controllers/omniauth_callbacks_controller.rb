class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def rtl
    active = Scenario.for_user(current_or_guest_user).recent.first
    @user = User.find_or_create_with_rtl!(request.env['omniauth.auth'])
    sign_in @user

    if active
      redirect_to scene_scenario_path(scene_id: active.scene_id, id: active.id)
    else
      redirect_to root_path, notice: "succesfully signed in!"
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
