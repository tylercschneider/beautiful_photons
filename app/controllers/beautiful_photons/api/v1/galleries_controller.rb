module BeautifulPhotons
  module Api
    module V1
      class GalleriesController < ApplicationController
        skip_forgery_protection

        def index
          galleries = Gallery.all
          render json: galleries.map { |gallery| gallery_json(gallery) }
        end

        def show
          gallery = Gallery.find(params[:id])
          render json: gallery_json(gallery)
        end

        def destroy
          gallery = Gallery.find(params[:id])
          gallery.destroy!
          head :no_content
        end

        def update
          gallery = Gallery.find(params[:id])

          if gallery.update(gallery_params)
            render json: gallery_json(gallery)
          else
            render json: { errors: gallery.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def create
          gallery = Gallery.new(gallery_params)

          if gallery.save
            render json: gallery_json(gallery), status: :created
          else
            render json: { errors: gallery.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def gallery_params
          params.require(:gallery).permit(:name, :title, :description)
        end

        def gallery_json(gallery)
          {
            id: gallery.id,
            name: gallery.name,
            title: gallery.title,
            description: gallery.description,
            created_at: gallery.created_at,
            updated_at: gallery.updated_at
          }
        end
      end
    end
  end
end
