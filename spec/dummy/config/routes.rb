Dummy::Application.routes.draw do
  root :to => "bettertabs#static"

  get 'bettertabs/ajax(/:ajax_selected_tab)', to: 'bettertabs#ajax'
  get 'bettertabs/:action(.:format)', controller: 'bettertabs'
end
