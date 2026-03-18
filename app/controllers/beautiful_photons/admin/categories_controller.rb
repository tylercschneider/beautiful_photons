# frozen_string_literal: true

module BeautifulPhotons
  module Admin
    class CategoriesController < BaseController
      skip_forgery_protection

      def index
        @categories = BeautifulPhotons::Category.all.order(:name)
        @category = BeautifulPhotons::Category.new
      end

      def create
        @category = BeautifulPhotons::Category.new(category_params)

        if @category.save
          redirect_to beautiful_photons.categories_path, notice: "Category created."
        else
          @categories = BeautifulPhotons::Category.all.order(:name)
          render :index, status: :unprocessable_entity
        end
      end

      def destroy
        @category = BeautifulPhotons::Category.find(params[:id])
        @category.destroy!
        redirect_to beautiful_photons.categories_path, notice: "Category deleted."
      end

      private

      def category_params
        params.require(:category).permit(:name)
      end
    end
  end
end
