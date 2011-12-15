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

    # ACTIONS ----------------------------------------------------------------

    ######
    public
    ######

    # Shows a list of all inputs used by the Scene.
    #
    # GET /backstage/scenes/:scene_id/inputs
    #
    def index
      @inputs = @scene.scene_inputs.includes(:input)
    end

    # Add a new scene input to the scene.
    #
    # POST /backstage/scenes/:scene_id/inputs
    #
    def create
      @input = @scene.scene_inputs.create(params[:scene_input])
      respond_with @input, location: backstage_scene_inputs_path
    end

    # Deletes a scene input.
    #
    # DELETE /backstage/scenes/:scene_id/inputs/:id
    #
    def destroy
      respond_with @input.destroy, location: backstage_scene_inputs_path
    end

  end # SceneInputsController
end # Backstage
