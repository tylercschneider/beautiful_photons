module BeautifulPhotons
  module Admin
    class StandalonesController < BaseController
      def index
        @standalones = Standalone.includes(:photo).order(:key)
      end

      def show
        @standalone = Standalone.find(params[:id])
      end

      def edit_crop
        @standalone = Standalone.find(params[:id])
      end

      def edit_mobile_crop
        @standalone = Standalone.find(params[:id])
      end

      def change_photo
        @standalone = Standalone.find(params[:id])
        @photos = Photo.all.order(created_at: :desc)
      end

      def update
        @standalone = Standalone.find(params[:id])
        @standalone.update!(standalone_params)

        message = if standalone_params.key?(:crop_x) || standalone_params.key?(:mobile_crop_x)
          "Crop saved."
        elsif standalone_params[:photo_id].present?
          "Photo assigned."
        elsif standalone_params.key?(:photo_id)
          "Photo removed."
        else
          "Updated."
        end

        redirect_to standalone_path(@standalone), notice: message
      end

      private

      def standalone_params
        permitted = params.require(:standalone).permit(
          :photo_id, :crop_x, :crop_y, :crop_zoom,
          :mobile_crop_x, :mobile_crop_y, :mobile_crop_zoom
        )
        permitted[:photo_id] = permitted[:photo_id].presence
        permitted
      end
    end
  end
end
