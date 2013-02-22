require 'rails'

module Bettertabs
  class Engine < Rails::Engine
    # Ensure BettertabsHelper is globally available.
    # Otherwise, if config.action_controller.include_all_helpers = false, the Bettertabs helper would not be included.
    # More info about this issue:
    # http://stackoverflow.com/questions/8797690/rails-3-1-better-way-to-expose-an-engines-helper-within-the-client-app
    initializer 'bettertabs.action_controller' do |app|
      ActiveSupport.on_load :action_controller do
        helper BettertabsHelper
      end
    end
  end
end