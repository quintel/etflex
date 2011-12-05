class Backstage::InputsController < ApplicationController
  include ETFlex::ClientController

  # FILTERS ------------------------------------------------------------------

  #######
  private
  #######

  before_filter :fetch_input, except: [ :index, :new, :create ]

  # Retrieves the input specified in the params.
  #
  def fetch_input
    @input = Input.find(params[:id])
  end

  # ACTIONS ------------------------------------------------------------------

  ######
  public
  ######

  # Returns a JSON list of all inputs present in the database.
  #
  # GET /backstage/inputs
  #
  def index
    respond_with @inputs = Input.all
  end

  # Updates an input with the supplied params.
  #
  # PUT /backstage/inputs/:id
  #
  def update
    @input.update_attributes(params[:input])
    respond_with @input
  end

end
