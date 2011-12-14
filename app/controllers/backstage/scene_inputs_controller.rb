module Backstage
  # Provides features so that a user may edit the values used for inputs in an
  # individual scene.
  #
  class SceneInputsController < InputsController
    prepend_view_path 'app/views/backstage/inputs'

    # FILTERS ----------------------------------------------------------------

    #######
    private
    #######

    before_filter :fetch_scene

    # Retrieves the scene specified in the params.
    #
    def fetch_scene
      @scene = Scene.find(params[:scene_id]) unless @scene
    end

    # Retrieves the scene input specified in the params.
    #
    def fetch_input
      @input = (@scene or fetch_scene).scene_inputs.find(params[:id])
    end

  end # SceneInputsController
end # Backstage
