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
