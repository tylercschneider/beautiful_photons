require "test_helper"

module BeautifulPhotons
  class PhotoTest < ActiveSupport::TestCase
    setup do
      @photo = Photo.new(title: "Test Photo")
      @photo.image.attach(
        io: File.open(file_fixture("test_image.jpg")),
        filename: "test_image.jpg",
        content_type: "image/jpeg"
      )
    end

    test "valid with image and defaults" do
      assert @photo.valid?
    end

    test "invalid without image" do
      photo = Photo.new(title: "No Image")
      assert_not photo.valid?
      assert_includes photo.errors[:image], "can't be blank"
    end

    test "defaults focal point to center" do
      assert_equal 50.0, @photo.focal_x
      assert_equal 50.0, @photo.focal_y
    end

    test "defaults published to false" do
      assert_equal false, @photo.published
    end

    test "validates focal_x within 0-100" do
      @photo.focal_x = 101
      assert_not @photo.valid?

      @photo.focal_x = -1
      assert_not @photo.valid?

      @photo.focal_x = 75
      assert @photo.valid?
    end

    test "validates focal_y within 0-100" do
      @photo.focal_y = 101
      assert_not @photo.valid?

      @photo.focal_y = 0
      assert @photo.valid?
    end

    test "allows nil mobile focal points" do
      @photo.mobile_focal_x = nil
      @photo.mobile_focal_y = nil
      assert @photo.valid?
    end

    test "validates mobile focal points within 0-100 when set" do
      @photo.mobile_focal_x = 150
      assert_not @photo.valid?

      @photo.mobile_focal_x = 30
      assert @photo.valid?
    end

    test "effective_mobile_focal_x falls back to focal_x" do
      @photo.focal_x = 60
      @photo.mobile_focal_x = nil
      assert_equal 60, @photo.effective_mobile_focal_x

      @photo.mobile_focal_x = 40
      assert_equal 40, @photo.effective_mobile_focal_x
    end

    test "effective_mobile_focal_y falls back to focal_y" do
      @photo.focal_y = 70
      @photo.mobile_focal_y = nil
      assert_equal 70, @photo.effective_mobile_focal_y

      @photo.mobile_focal_y = 20
      assert_equal 20, @photo.effective_mobile_focal_y
    end

    test "published scope returns only published photos" do
      @photo.published = true
      @photo.save!

      unpublished = Photo.new(title: "Unpublished")
      unpublished.image.attach(
        io: File.open(file_fixture("test_image.jpg")),
        filename: "test_image.jpg",
        content_type: "image/jpeg"
      )
      unpublished.save!

      assert_includes Photo.published, @photo
      assert_not_includes Photo.published, unpublished
    end
  end
end
