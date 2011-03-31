module BettertabsHelper

  # Bettertabs helper
  # Defines the bettertabs markup in the view.
  def bettertabs(bettertabs_id, options={})
    bettertabs_id = bettertabs_id.to_s
    selected_tab_id = params[:"#{bettertabs_id}_selected_tab"] || options.delete(:selected_tab)
    options[:class] = "bettertabs #{options[:class]}" # is important to keep the 'bettertabs' class even when the user adds more classes.
    options[:id] ||= bettertabs_id
    tabbuilder = BettertabsBuilder.new(bettertabs_id, self, selected_tab_id, options)
    yield(tabbuilder)
    tabbuilder.render
  end
  
end