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

      test "GET /standalones/:id shows standalone with available photos" do
        standalone = BeautifulPhotons::Standalone.create!(key: "about_hero")
        create_photo(title: "Available Photo")

        get standalone_url(standalone)

        assert_response :ok
        assert_select "img[alt='Available Photo']"
      end

      test "PATCH /standalones/:id assigns a photo" do
        standalone = BeautifulPhotons::Standalone.create!(key: "about_hero")
        photo = create_photo(title: "Assigned Photo")

        patch standalone_url(standalone), params: { standalone: { photo_id: photo.id } }, as: :json

        assert_redirected_to standalone_path(standalone)
        assert_equal photo.id, standalone.reload.photo_id
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
