module BeautifulPhotons
  module Admin
    class BaseController < ::ApplicationController
      before_action { send(BeautifulPhotons.config.authentication_method) }
      layout -> { BeautifulPhotons.config.admin_layout }

      helper KeystoneUi::Engine.helpers
    end
  end
end
