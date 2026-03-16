# frozen_string_literal: true

require "test_helper"

module BeautifulPhotons
  class GalleriesControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    setup do
      @routes = Engine.routes
    end

    test "GET /galleries renders the gallery list" do
      gallery = BeautifulPhotons::Gallery.create!(name: "homepage", title: "Homepage Gallery")

      get galleries_url

      assert_response :ok
      assert_select "h1", "Galleries"
      assert_select "a", "Homepage Gallery"
    end

    test "GET /galleries/:id shows photos in position order" do
      gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
      photo_a = create_photo(title: "First")
      photo_b = create_photo(title: "Second")
      BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo_b, position: 1)
      BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo_a, position: 2)

      get gallery_url(gallery)

      assert_response :ok
      assert_match "Portfolio", response.body
      assert_select "img[alt='Second']"
      assert_select "img[alt='First']"
    end

    test "PATCH /galleries/:id/reorder updates photo positions" do
      gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
      photo_a = create_photo(title: "A")
      photo_b = create_photo(title: "B")
      gp_a = BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo_a, position: 1)
      gp_b = BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo_b, position: 2)

      patch reorder_gallery_url(gallery), params: { photo_ids: [ photo_b.id, photo_a.id ] }, as: :json

      assert_response :ok
      assert_equal 1, gp_b.reload.position
      assert_equal 2, gp_a.reload.position
    end

    private

    def create_photo(title: "Test Photo")
      photo = BeautifulPhotons::Photo.new(title: title)
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
