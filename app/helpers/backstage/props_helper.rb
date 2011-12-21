module Backstage::PropsHelper

  # Returns the HTML containing a list of available props so that the user may
  # select one when adding a new scene prop.
  #
  # form - The form builder object.
  #
  def scene_prop_key_select(form)
    props = Prop.scoped.only(:id, :key).map do |prop|
      [ %|#{ I18n.t "props.#{ prop.key }.name" } (#{ prop.key })|, prop.id ]
    end

    props.sort_by! { |(name, key)| name }

    form.association :prop, collection: props, include_blank: false
  end

  # Returns the link to the CoffeeScript class on Github for the given prop.
  #
  def link_to_prop_behaviour(prop)
    path   = prop.behaviour.underscore
    path   = "headers/#{ path }" if prop.location == 'header'

    branch = if Rails.env.production? then 'production' else 'master' end

    url    = "https://github.com/dennisschoenmakers/etflex/tree/#{branch}/" \
             "client/views/props/#{ path }.coffee"

    link_to prop.behaviour, url,
      target:  '_blank',
      confirm: <<-CONFIRM.strip_heredoc.gsub("\n", ' ')
        This will take you to Github where you can inspect/adjust the
        CoffeeScript code. Make sure you have access or you will receive a
        'Not Found' error. Do you want to continue?
      CONFIRM
  end

end # Backstage::PropsHelper
