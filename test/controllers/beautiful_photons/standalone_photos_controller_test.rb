# frozen_string_literal: true

require "test_helper"

module BeautifulPhotons
  class StandalonePhotosControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "GET /standalone_photo/:key renders image in turbo frame" do
      photo = create_photo(title: "Hero Shot")
      standalone = Standalone.create!(key: "hero", photo: photo, crop_x: 30, crop_y: 70)

      get standalone_photo_url("hero")

      assert_response :ok
      assert_select "turbo-frame#bp-photo-hero"
      assert_select "img[alt='Hero Shot']"
      assert_includes response.body, "object-position: 30.0% 70.0%"
    end

    test "GET /standalone_photo/:key returns no_content when no photo" do
      Standalone.create!(key: "empty")

      get standalone_photo_url("empty")

      assert_response :no_content
    end

    test "GET /standalone_photo/:key sets cache headers" do
      photo = create_photo
      Standalone.create!(key: "cached", photo: photo)

      get standalone_photo_url("cached")

      assert_response :ok
      assert_match(/max-age=/, response.headers["Cache-Control"])
      assert_match(/public/, response.headers["Cache-Control"])
    end

    private

    def create_photo(title: "Test Photo")
      photo = Photo.new(title: title)
      photo.image.attach(
        io: File.open(File.expand_path("../../fixtures/files/test_image.jpg", __dir__)),
        filename: "test_image.jpg",
        content_type: "image/jpeg"
      )
      photo.save!
      photo
    end
  end
end
