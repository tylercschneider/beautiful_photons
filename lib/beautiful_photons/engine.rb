module BeautifulPhotons
  class Engine < ::Rails::Engine
    isolate_namespace BeautifulPhotons

    initializer "beautiful_photons.migrations" do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
    end

    initializer "beautiful_photons.importmap", before: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths << root.join("config/importmap.rb")
      end
    end

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
