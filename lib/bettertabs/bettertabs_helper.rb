module BettertabsHelper

  # Bettertabs helper
  # Defines the bettertabs markup in the view.
  def bettertabs(bettertabs_id, options={})
    bettertabs_id = bettertabs_id.to_s
    selected_tab_id = params[:"#{bettertabs_id}_selected_tab"] || options.delete(:selected_tab)
    options[:class] ||= "bettertabs"
    options[:id] ||= bettertabs_id
    options[:render_only_active_content] = true if controller.request.xhr?
    builder = BettertabsBuilder.new(bettertabs_id, self, selected_tab_id, options)
    yield(builder)
    builder.render
  end
  
end