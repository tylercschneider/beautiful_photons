module BeautifulPhotons
  class Engine < ::Rails::Engine
    isolate_namespace BeautifulPhotons

    initializer "beautiful_photons.url_helpers" do
      ActiveSupport.on_load(:action_controller) do
        helper Rails.application.routes.url_helpers
      end
    end
  end
end
