# A collection of helpers used exclusively by the Backstage actions, such as
# static navigation, etc.
module BackstageHelper

  # NAVIGATION ---------------------------------------------------------------

  # Creates HTML for the main Backstage navigation menu. Contains only the
  # main <li> elements.
  #
  # Returns a string containing the HTML.
  #
  def backstage_navigation
    items = []

    items << backstage_navigation_item(
      :scenes,  backstage_scenes_path, %w( scenes scene_inputs scene_props ))

    items << backstage_navigation_item(:inputs,    backstage_inputs_path)
    items << backstage_navigation_item(:queries,   '#')
    items << backstage_navigation_item(:props,     '#')
    items << backstage_navigation_item(:front_end, '/')

    items.join("\n").html_safe
  end

  # Renders an item on the Backstage menu. Not as nice as a dedicated plugin,
  # but we can add something more elaborate later if the need arises.
  #
  # id          - Some unique identifier for the navigation item. Used both as
  #               the CSS class for the item, and to retrieve the translated
  #               names.
  #
  # href        - A link to the backstage page.
  #
  # controllers - Backstage controllers on which the navigation item should be
  #               shown as being active. Omit the leading "backstage/". If
  #               this argument is not supplied, it will be assumed that the
  #               active controller for the item matches the given "id".
  #
  def backstage_navigation_item(id, href, controllers = [])
    if controllers.empty? then controllers = [ id.to_s ] end

    selected = controllers.any? { |c| c == controller_name } && ' selected'

    title    = t :"backstage.navigation.#{id}.title"
    name     = t :"backstage.navigation.#{id}.name"

    <<-HTML.html_safe
      <li class="#{ h id }#{ selected or '' }">
        <a href="#{ href }" title="#{ h title }">
          <span class="icon">#{ h name }</span>
        </a>
      </li>
    HTML
  end


end # BackstageHelper
