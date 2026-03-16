module BeautifulPhotons
  module Admin
    class BaseController < ::ApplicationController
      before_action { send(BeautifulPhotons.config.authentication_method) }
      layout "beautiful_photons/admin"

      helper KeystoneUi::Engine.helpers
    end
  end
end
