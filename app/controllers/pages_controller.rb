class PagesController < ApplicationController
  helper ScenesHelper

  # The root page.
  #
  # GET /
  #
  def root
    @scenes = Scene.limit(10)
  end

end
