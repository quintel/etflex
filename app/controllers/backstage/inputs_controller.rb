class Backstage::InputsController < ApplicationController
  respond_to :html, :json

  # Actions ------------------------------------------------------------------

  # Returns a JSON list of all inputs present in the database.
  #
  # GET /backstage/inputs
  #
  def index
    @inputs = Input.all
  end

end
