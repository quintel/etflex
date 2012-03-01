class HomeController < ApplicationController
  helper ScenesHelper

  # The root page.
  #
  # GET /
  #
  def root
    @scenes = Scene.all
  end

  # A test page for Pusher.
  #
  # GET /pusher
  #
  def pusher
  end

end
