Dummy::Application.routes.draw do
  root :to => "bettertabs#static"

  match 'bettertabs/:action(.:format)', controller: 'bettertabs'
end
