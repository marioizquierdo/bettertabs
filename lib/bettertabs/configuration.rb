module Bettertabs
  class Configuration
    attr_accessor :attach_jquery_bettertabs_inline

    def initialize
      @attach_jquery_bettertabs_inline = true
    end
  end
end
