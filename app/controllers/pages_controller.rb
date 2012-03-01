class PagesController < ApplicationController
  helper ScenesHelper

  # The root page.
  #
  # GET /
  #
  def root
    @scenes = Scene.limit(10)
  end

  # A test page for Pusher.
  #
  # GET /pusher
  #
  def pusher
  end

end
