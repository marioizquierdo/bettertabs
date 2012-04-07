require 'bettertabs/configuration'
require 'bettertabs/engine'
require 'bettertabs/bettertabs_builder'

module Bettertabs
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
