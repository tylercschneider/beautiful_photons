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
  end
end
