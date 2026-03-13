module BeautifulPhotons
  module Api
    module V1
      class GalleryPhotosController < ApplicationController
        skip_forgery_protection

        def index
          gallery = Gallery.find(params[:gallery_id])
          gallery_photos = gallery.gallery_photos.order(:position)
          render json: gallery_photos.map { |gp| gallery_photo_json(gp) }
        end

        def create
          gallery = Gallery.find(params[:gallery_id])
          gallery_photo = gallery.gallery_photos.new(gallery_photo_params)

          if gallery_photo.save
            render json: gallery_photo_json(gallery_photo), status: :created
          else
            render json: { errors: gallery_photo.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          gallery = Gallery.find(params[:gallery_id])
          gallery_photo = gallery.gallery_photos.find(params[:id])
          gallery_photo.destroy!
          head :no_content
        end

        def update
          gallery = Gallery.find(params[:gallery_id])
          gallery_photo = gallery.gallery_photos.find(params[:id])

          if gallery_photo.update(gallery_photo_params.except(:photo_id))
            render json: gallery_photo_json(gallery_photo)
          else
            render json: { errors: gallery_photo.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def gallery_photo_params
          params.require(:gallery_photo).permit(:photo_id, :position, :category)
        end

        def gallery_photo_json(gallery_photo)
          {
            id: gallery_photo.id,
            gallery_id: gallery_photo.gallery_id,
            photo_id: gallery_photo.photo_id,
            position: gallery_photo.position,
            category: gallery_photo.category,
            created_at: gallery_photo.created_at,
            updated_at: gallery_photo.updated_at
          }
        end
      end
    end
  end
end
