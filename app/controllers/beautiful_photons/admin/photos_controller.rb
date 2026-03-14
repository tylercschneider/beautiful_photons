module BeautifulPhotons
  module Admin
    class PhotosController < ApplicationController
      skip_forgery_protection

      def index
        @photos = BeautifulPhotons::Photo.all.order(created_at: :desc)
      end

      def show
        @photo = BeautifulPhotons::Photo.find(params[:id])
      end

      def update
        @photo = BeautifulPhotons::Photo.find(params[:id])
        @photo.update!(photo_params)
        redirect_to admin_photo_path(@photo)
      end

      private

      def photo_params
        params.require(:photo).permit(:title, :description, :focal_x, :focal_y, :mobile_focal_x, :mobile_focal_y, :published)
      end
    end
  end
end
