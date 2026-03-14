module BeautifulPhotons
  module Admin
    class PhotosController < ApplicationController
      def index
        @photos = BeautifulPhotons::Photo.all.order(created_at: :desc)
      end

      def show
        @photo = BeautifulPhotons::Photo.find(params[:id])
      end
    end
  end
end
