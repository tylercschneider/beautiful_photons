# frozen_string_literal: true

module BeautifulPhotons
  module Admin
    class GalleriesController < BaseController
      skip_forgery_protection

      def index
        @galleries = BeautifulPhotons::Gallery.all.order(:title)
      end

      def show
        @gallery = BeautifulPhotons::Gallery.find(params[:id])
        @gallery_photos = @gallery.gallery_photos.includes(:photo).order(:position)
        existing_ids = @gallery_photos.map(&:photo_id)
        @available_photos = BeautifulPhotons::Photo.where.not(id: existing_ids).order(created_at: :desc)
      end

      def reorder
        gallery = BeautifulPhotons::Gallery.find(params[:id])
        photo_ids = params[:photo_ids]

        photo_ids.each_with_index do |photo_id, index|
          gallery.gallery_photos.where(photo_id: photo_id).update_all(position: index + 1)
        end

        head :ok
      end

      def add_photos
        @gallery = BeautifulPhotons::Gallery.find(params[:id])
        max_position = @gallery.gallery_photos.maximum(:position) || 0

        Array(params[:photo_ids]).each_with_index do |photo_id, index|
          @gallery.gallery_photos.find_or_create_by!(photo_id: photo_id) do |gp|
            gp.position = max_position + index + 1
          end
        end

        redirect_to beautiful_photons.gallery_path(@gallery)
      end

      def remove_photo
        @gallery = BeautifulPhotons::Gallery.find(params[:id])
        @gallery.gallery_photos.where(photo_id: params[:photo_id]).destroy_all
        redirect_to beautiful_photons.gallery_path(@gallery)
      end
    end
  end
end
