module BeautifulPhotons
  module Admin
    class StandalonesController < BaseController
      def index
        @standalones = Standalone.includes(:photo).order(:key)
      end
    end
  end
end
