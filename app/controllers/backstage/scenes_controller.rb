class Backstage::ScenesController < ApplicationController
  layout 'backstage'
  respond_to :html, :json

  # FILTERS ------------------------------------------------------------------

  #######
  # privateScenes
  #######

  before_filter :fetch_input, except: [ :index, :new, :create ]

  # Retrieves the input specified in the params.
  #
  def fetch_input
    @scene = scene.find(params[:id].to_i)
  end

  # ACTIONS ------------------------------------------------------------------

  ######
  public
  ######

  # Returns a list of all scenes present in the database.
  #
  # GET /backstage/inputs
  #
  def index
    respond_with @scenes = Scene.all
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

end
