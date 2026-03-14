module BeautifulPhotons
  module Admin
    class PhotosController < ApplicationController
      def index
        @photos = BeautifulPhotons::Photo.all.order(created_at: :desc)
      end
    end
  end
end
