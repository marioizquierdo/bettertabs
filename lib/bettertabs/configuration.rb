module Bettertabs
  class Configuration
    attr_accessor :attach_jquery_bettertabs_inline

    def initialize
      # defaults
      @attach_jquery_bettertabs_inline = false
    end
  end
end
