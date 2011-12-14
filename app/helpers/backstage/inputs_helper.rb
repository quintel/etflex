module Backstage::InputsHelper

  # Returns the name for the input, as it should appear in the table which
  # lists all inputs. When no I18n name is defined, a lighter version of the
  # input key will be used instead.
  #
  # input - The Input instance whose name is being shown.
  #
  def input_name_for_list(input)
    fallback = %(<span class="missing-name">#{ h input.key }</span>).html_safe
    t("inputs.#{ input.key }.name", default: fallback)
  end

  # Returns the name of the input, suitable for use in the header of input
  # pages. Shows the I18n name if one is set, and the key.
  #
  # input - The input instance whose name is to be returned.
  #
  def input_name_for_title(input)
    translated = t("inputs.#{ input.key }.name", default: '')

    if translated.blank? then input.key else
      %(#{ h translated }
        <span class='quiet'>#{ h input.key}</span>
      ).html_safe
    end
  end

  # Returns a link to the list of inputs, based on the given argument.
  #
  # If a @scene ivar is set, the path returned will be to the list of scene
  # inputs, otherwise the path will be to the main inputs list.
  #
  def poly_backstage_inputs_path
    if @scene
      backstage_scene_inputs_path @scene
    else
      backstage_inputs_path
    end
  end

  # Returns a link to the edit form for an input. Correctly handles both Input
  # and SceneInputs, which is more than can be said for Rails' built-in
  # *_polymorphic_path.
  #
  def poly_backstage_input_path(input = nil, action = nil)
    # backstage_input_path, or backstage_scene_input_path
    route_name = "backstage_#{ input.class.name.underscore }_path"

    # Prefixes "edit", "custom action", etc...
    route_name = "#{ action }_#{ route_name }" if action.present?

    # SceneInput routes require a Scene.
    scene = if input.respond_to?(:scene) then input.scene end

    # Generate the URL. Scene will be set when routing
    __send__(route_name, *[ scene, input ].compact)
  end

end
