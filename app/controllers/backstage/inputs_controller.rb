module Backstage
  class InputsController < BackstageController

    # JSON templates exist for this controller, but I don't know if JSON
    # support is needed right now...
    respond_to :html, :json

    # FILTERS ----------------------------------------------------------------

    #######
    private
    #######

    before_filter :fetch_input, except: [ :index, :new, :create ]

    # Retrieves the input specified in the params.
    #
    def fetch_input
      # TODO Spec params[:id] not accepting .to_i
      @input = Input.find(params[:id].to_i)
    end

    # ACTIONS ----------------------------------------------------------------

    ######
    public
    ######

    # Returns a JSON list of all inputs present in the database.
    #
    # GET /backstage/inputs
    #
    def index
      if params[:scene_id]
        respond_with @inputs = Scene.find(params[:scene_id]).inputs.order('`key` ASC')
      else
        respond_with @inputs = Input.order('`key` ASC')
      end
    end

    # Shows a form allowing a user to edit an input.
    #
    # GET /backstage/inputs/:id/edit
    #
    def edit
      respond_with @input
    end

    # Updates an input with the supplied params.
    #
    # PUT /backstage/inputs/:id
    #
    def update
      @input.update_attributes(params[:input])
      respond_with @input, location: backstage_inputs_path
    end

  end # InputsController
end # Backstage
