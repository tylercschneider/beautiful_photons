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

        test "GET /api/v1/photos/:id returns a single photo" do
          photo = create_photo(title: "Mountain")

          get api_v1_photo_url(photo)

          assert_response :ok

          json = JSON.parse(response.body)
          assert_equal "Mountain", json["title"]
          assert_equal photo.id, json["id"]
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

        test "PATCH /api/v1/photos/:id updates metadata and focal points" do
          photo = create_photo(title: "Old Title")

          patch api_v1_photo_url(photo), params: {
            photo: { title: "New Title", focal_x: 25.0, focal_y: 75.0, published: true }
          }

          assert_response :ok

          json = JSON.parse(response.body)
          assert_equal "New Title", json["title"]
          assert_equal 25.0, json["focal_x"]
          assert_equal 75.0, json["focal_y"]
          assert_equal true, json["published"]
        end

        test "PATCH /api/v1/photos/:id returns 422 with invalid focal points" do
          photo = create_photo

          patch api_v1_photo_url(photo), params: { photo: { focal_x: 150 } }

          assert_response :unprocessable_entity

          json = JSON.parse(response.body)
          assert json["errors"].any? { |e| e.include?("Focal x") }
        end

        test "DELETE /api/v1/photos/:id destroys a photo" do
          photo = create_photo

          assert_difference("BeautifulPhotons::Photo.count", -1) do
            delete api_v1_photo_url(photo)
          end

          assert_response :no_content
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
