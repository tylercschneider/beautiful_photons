require "test_helper"

module BeautifulPhotons
  module Api
    module V1
      class PhotosControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers

        setup do
          @routes = Engine.routes
          @image = fixture_file_upload(
            File.expand_path("../../../../fixtures/files/test_image.jpg", __dir__),
            "image/jpeg"
          )
        end

        test "POST /api/v1/photos creates a photo" do
          assert_difference("BeautifulPhotons::Photo.count", 1) do
            post api_v1_photos_url, params: { photo: { title: "Sunset", image: @image } }
          end

          assert_response :created

          json = JSON.parse(response.body)
          assert_equal "Sunset", json["title"]
          assert_equal 50.0, json["focal_x"]
          assert_equal 50.0, json["focal_y"]
        end

        test "GET /api/v1/photos returns list of photos" do
          photo = create_photo(title: "Beach")

          get api_v1_photos_url

          assert_response :ok

          json = JSON.parse(response.body)
          assert_equal 1, json.length
          assert_equal "Beach", json.first["title"]
          assert_equal photo.id, json.first["id"]
        end

        test "POST /api/v1/photos returns 422 without image" do
          post api_v1_photos_url, params: { photo: { title: "No Image" } }

          assert_response :unprocessable_entity

          json = JSON.parse(response.body)
          assert_includes json["errors"], "Image can't be blank"
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
