require "test_helper"

module BeautifulPhotons
  module Admin
    class PhotosControllerTest < ActionDispatch::IntegrationTest
      include Engine.routes.url_helpers

      setup do
        @routes = Engine.routes
      end

      test "GET /photos renders the photo library" do
        photo = create_photo(title: "Sunset Beach")

        get photos_url

        assert_response :ok
        assert_select "h1", "Photos"
        assert_select "img[alt='Sunset Beach']"
      end

      test "GET /photos/:id renders the photo detail page" do
        photo = create_photo(title: "Mountain View")

        get photo_url(photo)

        assert_response :ok
        assert_select "img[alt='Mountain View']"
      end

      test "PATCH /photos/:id updates focal points" do
        photo = create_photo(title: "Beach")

        patch photo_url(photo), params: { photo: { focal_x: 30.0, focal_y: 70.0 } }, as: :json

        assert_response :redirect
        photo.reload
        assert_equal 30.0, photo.focal_x
        assert_equal 70.0, photo.focal_y
      end

      test "GET /photos/:id/edit renders the focal point editor" do
        photo = create_photo(title: "Lake Photo")

        get edit_photo_url(photo)

        assert_response :ok
        assert_select "img[alt='Lake Photo']"
        assert_select "form"
      end

      test "GET /photos links each photo to its show page" do
        photo = create_photo(title: "Linked Photo")

        get photos_url

        assert_select "a[href='#{photo_path(photo)}']"
      end

      test "GET /photos/:id/edit renders focal point picker with pin" do
        photo = create_photo(title: "Garden")

        get edit_photo_url(photo)

        assert_response :ok
        assert_select "[data-focal-point-target='image']"
        assert_select "[data-focal-point-target='pin']"
        assert_select "input[name='photo[focal_x]']"
        assert_select "input[name='photo[focal_y]']"
      end

      test "GET /photos has an upload link" do
        get photos_url

        assert_response :ok
        assert_match "Upload", response.body
        assert_match "/beautiful_photons/photos/new", response.body
      end

      test "POST /photos creates a photo and redirects" do
        image = fixture_file_upload("test_image.jpg", "image/jpeg")

        assert_difference("BeautifulPhotons::Photo.count", 1) do
          post photos_url, params: { photo: { title: "New Upload", image: image } }
        end

        photo = BeautifulPhotons::Photo.last
        assert_redirected_to photo_path(photo)
        assert_equal "New Upload", photo.title
        assert photo.image.attached?
      end

      test "GET /photos/new renders the upload form" do
        get new_photo_url

        assert_response :ok
        assert_select "form"
        assert_match "photo[image]", response.body
        assert_match "Title", response.body
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
