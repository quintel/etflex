module Backstage
  class ScenePropsController < BackstageController
    helper PropsHelper

    # FILTERS ----------------------------------------------------------------

    #######
    private
    #######

    before_filter :fetch_scene
    before_filter :fetch_prop, :except => [ :index, :new, :create ]

    # Retrieves the scene identified in the params.
    #
    def fetch_scene
      @scene = Scene.find(params[:scene_id])
    end

    # Retrieves the scene prop identified in the params.
    #
    def fetch_prop
      @prop = @scene.scene_props.find(params[:id])
    end

    # Returns the sanitized parameters for creating and editing props.
    #
    def prop_params
      params.require(:scene_prop).permit(:location, :prop_id, :position)
    end

    # ACTIONS ----------------------------------------------------------------

    ######
    public
    ######

    # Shows a list of all props used by the scene.
    #
    # GET /backstage/scenes/:scene_id/props
    #
    def index
      @props = @scene.scene_props.includes(:prop)
    end

    # Shows a form for adding a new scene prop.
    #
    # GET /backstage/scenes/:scene_id/props/new
    #
    def new
      @prop = @scene.scene_props.build
    end

    # Adds a new scene prop to the scene.
    #
    # POST /backstage/scenes/:scene_id/props
    #
    def create
      @prop = @scene.scene_props.create(prop_params)
      respond_with @prop, location: backstage_scene_props_path
    end

    # Updates a scene prop.
    #
    # PUT /backstage/scenes/:scene_id/props/:id
    #
    def update
      @prop.update_attributes(prop_params)
      respond_with @prop, location: backstage_scene_props_path
    end

    # Deletes a scene prop.
    #
    # DELETE /backstage/scenes/:scene_id/props/:id
    #
    def destroy
      respond_with @prop.destroy, location: backstage_scene_props_path
    end

  end # ScenePropsController
end # Backstage
