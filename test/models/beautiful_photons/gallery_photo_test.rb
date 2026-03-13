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
  end
end
