module BeautifulPhotons
  module Api
    class BaseController < ::ApplicationController
      skip_forgery_protection

      before_action :authenticate_api!

      private

      def authenticate_api!
        send(BeautifulPhotons.config.api_authentication_method)
      end
    end
  end
end
