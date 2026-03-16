require "beautiful_photons/version"
require "beautiful_photons/engine"

module BeautifulPhotons
  class Configuration
    attr_accessor :admin_layout, :authentication_method, :current_user_method

    def initialize
      @admin_layout = "application"
      @authentication_method = :authenticate_user!
      @current_user_method = :current_user
    end
  end

  class << self
    def configure
      yield(config)
    end

    def config
      @config ||= Configuration.new
    end

    def reset_config!
      @config = Configuration.new
    end
  end
end
