module BeautifulPhotons
  module Api
    module V1
      class PhotosController < ApplicationController
        skip_forgery_protection

        def index
          photos = Photo.all
          render json: photos.map { |photo| photo_json(photo) }
        end

        def show
          photo = Photo.find(params[:id])
          render json: photo_json(photo)
        end

        def create
          photo = Photo.new(photo_params)

          if photo.save
            render json: photo_json(photo), status: :created
          else
            render json: { errors: photo.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def photo_params
          params.require(:photo).permit(:title, :description, :image, :focal_x, :focal_y,
                                        :mobile_focal_x, :mobile_focal_y)
        end

        def photo_json(photo)
          {
            id: photo.id,
            title: photo.title,
            description: photo.description,
            focal_x: photo.focal_x.to_f,
            focal_y: photo.focal_y.to_f,
            mobile_focal_x: photo.mobile_focal_x&.to_f,
            mobile_focal_y: photo.mobile_focal_y&.to_f,
            published: photo.published,
            created_at: photo.created_at,
            updated_at: photo.updated_at
          }
        end
      end
    end
  end
end
