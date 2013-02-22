require 'rails'

module Bettertabs
  class Engine < Rails::Engine
    initializer 'bettertabs.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper BettertabsHelper
      end
    end
  end
end