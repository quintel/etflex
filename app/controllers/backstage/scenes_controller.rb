module Backstage
  class ScenesController < BackstageController

    # FILTERS ----------------------------------------------------------------

    #######
    private
    #######

    before_action :fetch_scene, except: [ :index, :new, :create ]

    # Retrieves the input specified in the params.
    #
    def fetch_scene
      @scene = Scene.find(params[:id])
    end

    # Returns the sanitized parameters for creating and editing props.
    #
    def scene_params
      params.require(:scene).permit(:name, :name_key, :score_gquery)
    end

    # ACTIONS ----------------------------------------------------------------

    ######
    public
    ######

    # Returns a list of all scenes present in the database.
    #
    # GET /backstage/scenes
    #
    def index
      respond_with @scenes = Scene.all
    end

    # Shows a form allowing a user to create a scene.
    #
    # GET /backstage/scenes/new
    #
    def new
      @scene = Scene.new
      respond_with @scene
    end

    # Creates a scene with the supplied params.
    #
    # POST /backstage/scenes
    #
    def create
      @scene = Scene.create(scene_params)
      respond_with @scene, location: backstage_scenes_path
    end

    # Shows a form allowing a user to edit a scene.
    #
    # GET /backstage/scenes/:id/edit
    #
    def edit
      respond_with @scene
    end

    # Updates a scene with the supplied params.
    #
    # PUT /backstage/scenes/:id
    #
    def update
      @scene.update_attributes(scene_params)
      respond_with @scene, location: backstage_scenes_path
    end

  end # ScenesController
end # Backstage
