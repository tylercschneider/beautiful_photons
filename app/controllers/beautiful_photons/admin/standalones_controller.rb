module BeautifulPhotons
  module Admin
    class StandalonesController < BaseController
      def index
        @standalones = Standalone.includes(:photo).order(:key)
      end

      def show
        @standalone = Standalone.find(params[:id])
        @photos = Photo.all.order(created_at: :desc)
      end
    end
  end
end
