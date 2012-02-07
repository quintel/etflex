class HomeController < ApplicationController

  # The root page.
  #
  # GET /
  #
  def root
    @scenes = Scene.all
  end

end
