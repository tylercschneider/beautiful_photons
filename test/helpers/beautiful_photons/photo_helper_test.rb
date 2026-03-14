require "test_helper"

module BeautifulPhotons
  class PhotoHelperTest < ActionView::TestCase
    include PhotoHelper

    setup do
      @photo = Photo.new(title: "Test", focal_x: 60, focal_y: 30)
      @photo.image.attach(
        io: File.open(file_fixture("test_image.jpg")),
        filename: "test_image.jpg",
        content_type: "image/jpeg"
      )
      @photo.save!
    end

    test "beautiful_photons_image renders img with focal point style" do
      html = beautiful_photons_image(@photo)

      assert_includes html, "object-position: 60.0% 30.0%"
      assert_includes html, "object-fit: cover"
      assert_includes html, "<img"
    end

    test "beautiful_photons_image accepts class and aspect options" do
      html = beautiful_photons_image(@photo, class: "hero-img", aspect: "4/3")

      assert_includes html, 'class="hero-img"'
      assert_includes html, "aspect-ratio: 4/3"
    end

    test "beautiful_photons_image includes mobile focal point data attributes" do
      @photo.update!(mobile_focal_x: 40, mobile_focal_y: 20)
      html = beautiful_photons_image(@photo)

      assert_includes html, 'data-mobile-focal-x="40.0"'
      assert_includes html, 'data-mobile-focal-y="20.0"'
    end

    test "beautiful_photons_gallery yields photos in position order" do
      gallery = Gallery.create!(name: "test_gallery", title: "Test")
      photo2 = create_photo("Second")
      GalleryPhoto.create!(gallery: gallery, photo: photo2, position: 1)
      GalleryPhoto.create!(gallery: gallery, photo: @photo, position: 2)

      titles = []
      beautiful_photons_gallery("test_gallery") { |photo| titles << photo.title }

      assert_equal %w[Second Test], titles
    end

    test "beautiful_photons_photos returns photos for a gallery" do
      gallery = Gallery.create!(name: "query_gallery", title: "Query")
      GalleryPhoto.create!(gallery: gallery, photo: @photo, position: 1)

      photos = beautiful_photons_photos("query_gallery")

      assert_equal 1, photos.length
      assert_equal @photo, photos.first
    end

    private

    def create_photo(title)
      photo = Photo.new(title: title)
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
