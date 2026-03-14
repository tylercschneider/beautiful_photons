module BeautifulPhotons
  class ApplicationController < ActionController::Base
    helper KeystoneUi::Engine.helpers
    helper Rails.application.routes.url_helpers
  end
end
