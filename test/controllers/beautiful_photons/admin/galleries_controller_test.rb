# frozen_string_literal: true

require "test_helper"

module BeautifulPhotons
  module Admin
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

      test "POST /galleries creates a gallery and redirects" do
        assert_difference("BeautifulPhotons::Gallery.count", 1) do
          post galleries_url, params: { gallery: { name: "test_gallery", title: "Test Gallery" } }
        end

        gallery = BeautifulPhotons::Gallery.last
        assert_redirected_to gallery_path(gallery)
        assert_equal "test_gallery", gallery.name
        assert_equal "Test Gallery", gallery.title
      end

      test "DELETE /galleries/:id/remove_photos bulk removes photos" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        photo_a = create_photo(title: "A")
        photo_b = create_photo(title: "B")
        BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo_a, position: 1)
        BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo_b, position: 2)

        assert_difference("BeautifulPhotons::GalleryPhoto.count", -2) do
          delete remove_photos_gallery_url(gallery), params: { photo_ids: [ photo_a.id, photo_b.id ] }
        end

        assert_response :redirect
      end

      test "GET /galleries/:id/add_photos_page shows available photos" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        create_photo(title: "Available")

        get add_photos_page_gallery_url(gallery)

        assert_response :ok
        assert_select "img[alt='Available']"
      end

      test "POST /galleries/:id/add_photos adds photos to gallery" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        photo_a = create_photo(title: "A")
        photo_b = create_photo(title: "B")

        assert_difference("BeautifulPhotons::GalleryPhoto.count", 2) do
          post add_photos_gallery_url(gallery), params: { photo_ids: [ photo_a.id, photo_b.id ] }, as: :json
        end

        assert_response :redirect
        assert_equal [ photo_a.id, photo_b.id ], gallery.gallery_photos.order(:position).pluck(:photo_id)
      end

      test "GET /galleries/:id has an edit button" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")

        get gallery_url(gallery)

        assert_response :ok
        assert_select "a[href='#{edit_gallery_path(gallery)}']", "Edit"
      end

      test "GET /galleries/:id has a delete button" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")

        get gallery_url(gallery)

        assert_response :ok
        assert_select "form[action='#{gallery_path(gallery)}'][method='post']" do
          assert_select "input[name='_method'][value='delete']"
          assert_select "button", "Delete"
        end
      end

      test "DELETE /galleries/:id destroys the gallery and redirects" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        photo = create_photo(title: "In Gallery")
        BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo, position: 1)

        assert_difference("BeautifulPhotons::Gallery.count", -1) do
          delete gallery_url(gallery)
        end

        assert_redirected_to galleries_path
        assert_equal "Gallery deleted.", flash[:notice]
        assert BeautifulPhotons::Photo.exists?(photo.id), "Photo should not be deleted"
      end

      test "POST /galleries/:id/add_photos saves category from form" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        photo = create_photo(title: "Backsplash")

        post add_photos_gallery_url(gallery), params: { photo_ids: [ photo.id ], category: "backsplashes" }

        gp = gallery.gallery_photos.find_by(photo_id: photo.id)
        assert_equal "backsplashes", gp.category
      end

      test "GET /galleries/:id/add_photos_page has a category field" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        create_photo(title: "Available")

        get add_photos_page_gallery_url(gallery)

        assert_response :ok
        assert_select "input[name='category']"
      end

      test "GET /galleries/:id shows category percentage stats" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        3.times { |i| BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: create_photo(title: "B#{i}"), position: i + 1, category: "backsplashes") }
        7.times { |i| BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: create_photo(title: "F#{i}"), position: i + 4, category: "floors") }

        get gallery_url(gallery)

        assert_response :ok
        assert_match "30% backsplashes", response.body
        assert_match "70% floors", response.body
      end

      test "GET /galleries/:id shows category labels on photos" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")
        photo = create_photo(title: "Backsplash Photo")
        BeautifulPhotons::GalleryPhoto.create!(gallery: gallery, photo: photo, position: 1, category: "backsplashes")

        get gallery_url(gallery)

        assert_response :ok
        assert_select ".gallery-photo-category", "backsplashes"
      end

      test "PATCH /galleries/:id updates the gallery and redirects" do
        gallery = BeautifulPhotons::Gallery.create!(name: "portfolio", title: "Portfolio")

        patch gallery_url(gallery), params: { gallery: { title: "Updated Portfolio", description: "A new description" } }

        assert_redirected_to gallery_path(gallery)
        gallery.reload
        assert_equal "Updated Portfolio", gallery.title
        assert_equal "A new description", gallery.description
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
