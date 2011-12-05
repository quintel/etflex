class Backstage::InputsController < ApplicationController
  include ETFlex::ClientController

  # Actions ------------------------------------------------------------------

  # Returns a JSON list of all inputs present in the database.
  #
  # GET /backstage/inputs
  #
  def index
    @inputs = Input.all
  end

end
