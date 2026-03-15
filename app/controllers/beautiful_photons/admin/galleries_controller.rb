# frozen_string_literal: true

module BeautifulPhotons
  module Admin
    class GalleriesController < ApplicationController
      def index
        @galleries = BeautifulPhotons::Gallery.all.order(:title)
      end
    end
  end
end
