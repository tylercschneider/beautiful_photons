# frozen_string_literal: true

require "test_helper"

module BeautifulPhotons
  module Admin
    class StandalonesControllerTest < ActionDispatch::IntegrationTest
      include Engine.routes.url_helpers

      setup do
        @routes = Engine.routes
      end

      test "GET /standalones renders the standalone list" do
        BeautifulPhotons::Standalone.create!(key: "about_hero", label: "About Hero")

        get standalones_url

        assert_response :ok
        assert_select "h1", "Standalones"
        assert_select "strong", "About Hero"
      end

      test "GET /standalones/:id shows standalone summary" do
        photo = create_photo(title: "My Photo")
        standalone = BeautifulPhotons::Standalone.create!(key: "about_hero", photo: photo)

        get standalone_url(standalone)

        assert_response :ok
        assert_select "strong", "My Photo"
      end

      test "GET /standalones/:id/change_photo shows photo grid" do
        standalone = BeautifulPhotons::Standalone.create!(key: "about_hero")
        create_photo(title: "Available Photo")

        get change_photo_standalone_url(standalone)

        assert_response :ok
        assert_select "img[alt='Available Photo']"
      end

      test "standalones index has nav link" do
        get standalones_url
        assert_select "a", "Standalones"
      end

      test "PATCH /standalones/:id assigns a photo" do
        standalone = BeautifulPhotons::Standalone.create!(key: "about_hero")
        photo = create_photo(title: "Assigned Photo")

        patch standalone_url(standalone), params: { standalone: { photo_id: photo.id } }, as: :json

        assert_redirected_to standalone_path(standalone)
        assert_equal photo.id, standalone.reload.photo_id
      end

      test "GET /standalones/:id/edit_crop shows crop editor" do
        photo = create_photo
        standalone = BeautifulPhotons::Standalone.create!(key: "hero", photo: photo, aspect: "2:1")

        get edit_crop_standalone_url(standalone)

        assert_response :ok
        assert_select "[data-controller='crop-editor']"
        assert_select "input[name='standalone[crop_x]']"
        assert_select "input[type='range']"
      end

      test "PATCH /standalones/:id saves crop data" do
        standalone = BeautifulPhotons::Standalone.create!(key: "hero")
        photo = create_photo

        patch standalone_url(standalone), params: {
          standalone: { photo_id: photo.id, crop_x: 30, crop_y: 70, crop_zoom: 1.5 }
        }, as: :json

        standalone.reload
        assert_equal 30.0, standalone.crop_x.to_f
        assert_equal 70.0, standalone.crop_y.to_f
        assert_equal 1.5, standalone.crop_zoom.to_f
      end

      private

      def create_photo(title: "Test Photo")
        photo = BeautifulPhotons::Photo.new(title: title)
        photo.image.attach(
          io: File.open(File.expand_path("../../../fixtures/files/test_image.jpg", __dir__)),
          filename: "test_image.jpg",
          content_type: "image/jpeg"
        )
        photo.save!
        photo
      end
    end
  end
end
