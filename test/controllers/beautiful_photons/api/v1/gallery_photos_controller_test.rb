require "test_helper"

module BeautifulPhotons
  module Api
    module V1
      class GalleryPhotosControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers

        setup do
          @routes = Engine.routes
          @gallery = Gallery.create!(name: "homepage", title: "Homepage")
          @photo = create_photo
        end

        test "POST /api/v1/galleries/:id/photos adds a photo to gallery" do
          assert_difference("BeautifulPhotons::GalleryPhoto.count", 1) do
            post api_v1_gallery_photos_url(@gallery), params: {
              gallery_photo: { photo_id: @photo.id, position: 1, category: "backsplashes" }
            }
          end

          assert_response :created

          json = JSON.parse(response.body)
          assert_equal @photo.id, json["photo_id"]
          assert_equal 1, json["position"]
          assert_equal "backsplashes", json["category"]
        end

        private

        def create_photo(title: "Test Photo")
          photo = BeautifulPhotons::Photo.new(title: title)
          photo.image.attach(
            io: File.open(file_fixture("test_image.jpg")),
            filename: "test_image.jpg",
            content_type: "image/jpeg"
          )
          photo.save!
          photo
        end
      end
    end
  end
end
