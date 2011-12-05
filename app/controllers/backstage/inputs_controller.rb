class Backstage::InputsController < ApplicationController
  respond_to :json
  respond_to :html, only: [ :index, :show, :new, :edit ]

  def self.responder
    ETFlex::ClientResponder
  end

  # Actions ------------------------------------------------------------------

  # Returns a JSON list of all inputs present in the database.
  #
  # GET /backstage/inputs
  #
  def index
    @inputs = Input.all
  end

end
