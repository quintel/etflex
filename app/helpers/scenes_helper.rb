module ScenesHelper
  # Returns the information for an input, based on the currently set locale.
  #
  # input - The input whose information is to be retrieved.
  #
  def information_for_input(input)
    information =
      if I18n.locale == :nl
        input.information_nl
      else
        input.information_en
      end.presence

    if information.nil? then nil else
      markdown = Redcarpet::Markdown.new(
        Redcarpet::Render::SmartyHTML.new(
          filter_html:    true,
          no_styles:      true,
          safe_link_only: true,
          xhtml:          true
        ),

        auto_link:           true,
        space_after_headers: true,
        no_intra_emphasis:   true,
        superscript:         true
      )

      markdown.render(information)
    end
  end
end
