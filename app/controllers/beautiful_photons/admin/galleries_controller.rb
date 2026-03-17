# frozen_string_literal: true

module BeautifulPhotons
  module Admin
    class GalleriesController < BaseController
      skip_forgery_protection

      def index
        @galleries = BeautifulPhotons::Gallery.all.order(:title)
      end

      def new
        @gallery = BeautifulPhotons::Gallery.new
      end

      def create
        @gallery = BeautifulPhotons::Gallery.new(gallery_params)

        if @gallery.save
          redirect_to beautiful_photons.gallery_path(@gallery)
        else
          render :new, status: :unprocessable_entity
        end
      end

      def show
        @gallery = BeautifulPhotons::Gallery.find(params[:id])
        @gallery_photos = @gallery.gallery_photos.includes(:photo).order(:position)
      end

      def add_photos_page
        @gallery = BeautifulPhotons::Gallery.find(params[:id])
        existing_ids = @gallery.gallery_photos.pluck(:photo_id)
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
        ids = Array(params[:photo_ids])

        ids.each_with_index do |photo_id, index|
          @gallery.gallery_photos.find_or_create_by!(photo_id: photo_id) do |gp|
            gp.position = max_position + index + 1
          end
        end

        redirect_to beautiful_photons.gallery_path(@gallery),
          notice: "Added #{ids.size} #{"photo".pluralize(ids.size)} to gallery."
      end

      def remove_photos
        @gallery = BeautifulPhotons::Gallery.find(params[:id])
        ids = Array(params[:photo_ids])
        @gallery.gallery_photos.where(photo_id: ids).destroy_all

        redirect_to beautiful_photons.gallery_path(@gallery),
          notice: "Removed #{ids.size} #{"photo".pluralize(ids.size)} from gallery."
      end

      private

      def gallery_params
        params.require(:gallery).permit(:name, :title, :description)
      end
    end
  end
end
