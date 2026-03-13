module BeautifulPhotons
  module Api
    module V1
      class GalleriesController < ApplicationController
        skip_forgery_protection

        def index
          galleries = Gallery.all
          render json: galleries.map { |gallery| gallery_json(gallery) }
        end

        private

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
