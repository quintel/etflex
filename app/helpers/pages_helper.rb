module PagesHelper
  def create_or_continue_playing_path(scene)
    previous_attempt = scene.previous_attempt(current_or_guest_user)

    if previous_attempt
      scene_scenario_path(scene_id: scene.id, id: previous_attempt)
    else
      scene_path(scene)
    end
  end
end
