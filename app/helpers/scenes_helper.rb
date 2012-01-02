module ScenesHelper
  # Returns the information for an input, based on the currently set locale.
  #
  # input - The input whose information is to be retrieved.
  #
  def information_for_input(input)
    if I18n.locale == :nl
      input.information_nl
    else
      input.information_en
    end.presence
  end
end
