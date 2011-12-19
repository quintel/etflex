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

end # Backstage::PropsHelper
