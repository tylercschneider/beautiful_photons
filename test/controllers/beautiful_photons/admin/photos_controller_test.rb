require "test_helper"

module BeautifulPhotons
  module Admin
    class PhotosControllerTest < ActionDispatch::IntegrationTest
      include Engine.routes.url_helpers

      setup do
        @routes = Engine.routes
      end

      test "GET /admin/photos renders the photo library" do
        photo = create_photo(title: "Sunset Beach")

        get admin_photos_url

        assert_response :ok
        assert_select "h1", "Photos"
        assert_select "img[alt='Sunset Beach']"
      end

      test "GET /admin/photos/:id renders the photo detail page" do
        photo = create_photo(title: "Mountain View")

        get admin_photo_url(photo)

        assert_response :ok
        assert_select "img[alt='Mountain View']"
      end

      test "PATCH /admin/photos/:id updates focal points" do
        photo = create_photo(title: "Beach")

        patch admin_photo_url(photo), params: { photo: { focal_x: 30.0, focal_y: 70.0 } }, as: :json

        assert_response :redirect
        photo.reload
        assert_equal 30.0, photo.focal_x
        assert_equal 70.0, photo.focal_y
      end

      test "GET /admin/photos/:id/edit renders the focal point editor" do
        photo = create_photo(title: "Lake Photo")

        get edit_admin_photo_url(photo)

        assert_response :ok
        assert_select "img[alt='Lake Photo']"
        assert_select "form"
      end

      test "GET /admin/photos links each photo to its edit page" do
        photo = create_photo(title: "Linked Photo")

        get admin_photos_url

        assert_select "a[href*='edit']"
      end

      test "GET /admin/photos/:id/edit renders focal point picker with pin" do
        photo = create_photo(title: "Garden")

        get edit_admin_photo_url(photo)

        assert_response :ok
        assert_select "[data-focal-point-target='image']"
        assert_select "[data-focal-point-target='pin']"
        assert_select "input[name='photo[focal_x]']"
        assert_select "input[name='photo[focal_y]']"
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
