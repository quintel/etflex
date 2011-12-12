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

end
