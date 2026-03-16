module BeautifulPhotons
  class ApplicationController < ::ApplicationController
    helper KeystoneUi::Engine.helpers
    helper Rails.application.routes.url_helpers
  end
end
