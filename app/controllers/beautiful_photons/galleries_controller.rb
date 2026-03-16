# frozen_string_literal: true

module BeautifulPhotons
  class GalleriesController < ApplicationController
    skip_forgery_protection

    def index
      @galleries = BeautifulPhotons::Gallery.all.order(:title)
    end

    def show
      @gallery = BeautifulPhotons::Gallery.find(params[:id])
      @gallery_photos = @gallery.gallery_photos.includes(:photo).order(:position)
    end

    def reorder
      gallery = BeautifulPhotons::Gallery.find(params[:id])
      photo_ids = params[:photo_ids]

      photo_ids.each_with_index do |photo_id, index|
        gallery.gallery_photos.where(photo_id: photo_id).update_all(position: index + 1)
      end

      head :ok
    end
  end
end
