require "test_helper"

module BeautifulPhotons
  class GalleryPhotoTest < ActiveSupport::TestCase
    setup do
      @gallery = Gallery.create!(name: "homepage", title: "Homepage")
      @photo = Photo.new(title: "Test")
      @photo.image.attach(
        io: File.open(file_fixture("test_image.jpg")),
        filename: "test_image.jpg",
        content_type: "image/jpeg"
      )
      @photo.save!
    end

    test "valid with gallery, photo, and position" do
      gallery_photo = GalleryPhoto.new(gallery: @gallery, photo: @photo, position: 1)
      assert gallery_photo.valid?
    end

    test "invalid without position" do
      gallery_photo = GalleryPhoto.new(gallery: @gallery, photo: @photo)
      assert_not gallery_photo.valid?
      assert_includes gallery_photo.errors[:position], "can't be blank"
    end

    test "photo can belong to same gallery with different categories" do
      GalleryPhoto.create!(gallery: @gallery, photo: @photo, position: 1, category: "backsplashes")
      second = GalleryPhoto.new(gallery: @gallery, photo: @photo, position: 2, category: "bathrooms")
      assert second.valid?
    end

    test "prevents duplicate gallery-photo-category combination" do
      GalleryPhoto.create!(gallery: @gallery, photo: @photo, position: 1, category: "backsplashes")
      duplicate = GalleryPhoto.new(gallery: @gallery, photo: @photo, position: 2, category: "backsplashes")
      assert_not duplicate.valid?
    end

    test "gallery has_many photos through gallery_photos" do
      GalleryPhoto.create!(gallery: @gallery, photo: @photo, position: 1)
      assert_includes @gallery.photos, @photo
    end
  end
end
