# frozen_string_literal: true

module BeautifulPhotons
  module Admin
    class GalleriesController < ApplicationController
      def index
        @galleries = BeautifulPhotons::Gallery.all.order(:title)
      end

      def show
        @gallery = BeautifulPhotons::Gallery.find(params[:id])
        @gallery_photos = @gallery.gallery_photos.includes(:photo).order(:position)
      end
    end
  end
end
