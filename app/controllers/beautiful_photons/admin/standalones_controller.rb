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

      def update
        @standalone = Standalone.find(params[:id])
        photo_id = params[:standalone][:photo_id].presence
        @standalone.update!(photo_id: photo_id)
        redirect_to standalone_path(@standalone)
      end
    end
  end
end
