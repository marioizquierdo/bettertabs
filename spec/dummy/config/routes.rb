Dummy::Application.routes.draw do
  root :to => "bettertabs#static"

  match 'bettertabs/ajax(/:ajax_selected_tab)' => 'bettertabs#ajax'
  match 'bettertabs/:action(.:format)', controller: 'bettertabs'
end
