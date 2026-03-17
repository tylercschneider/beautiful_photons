module BeautifulPhotons
  class Engine < ::Rails::Engine
    isolate_namespace BeautifulPhotons

    initializer "beautiful_photons.url_helpers" do
      ActiveSupport.on_load(:action_controller) do
        helper Rails.application.routes.url_helpers
      end
    end

    initializer "beautiful_photons.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        require_relative "../../app/helpers/beautiful_photons/photo_helper"
        include BeautifulPhotons::PhotoHelper
      end
    end
  end
end
