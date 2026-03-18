module BeautifulPhotons
  module Admin
    class PhotosController < BaseController
      skip_forgery_protection

      def index
        @photos = BeautifulPhotons::Photo.all.order(created_at: :desc)
      end

      def show
        @photo = BeautifulPhotons::Photo.find(params[:id])
      end

      def new
        @photo = BeautifulPhotons::Photo.new
      end

      def create
        @photo = BeautifulPhotons::Photo.new(photo_params)

        if @photo.save
          redirect_to beautiful_photons.photo_path(@photo), notice: "Photo uploaded."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def bulk_create
        images = Array(params[:images])
        count = 0

        images.each do |image|
          title = File.basename(image.original_filename, ".*").titleize
          photo = BeautifulPhotons::Photo.new(title: title)
          photo.image.attach(image)
          if photo.save
            count += 1
          end
        end

        redirect_to beautiful_photons.photos_path,
          notice: "Uploaded #{count} #{"photo".pluralize(count)}."
      end

      def edit
        @photo = BeautifulPhotons::Photo.find(params[:id])
      end

      def update
        @photo = BeautifulPhotons::Photo.find(params[:id])
        @photo.update!(photo_params)
        redirect_to beautiful_photons.photo_path(@photo)
      end

      private

      def photo_params
        params.require(:photo).permit(:title, :description, :image, :focal_x, :focal_y, :mobile_focal_x, :mobile_focal_y, :published)
      end
    end
  end
end
