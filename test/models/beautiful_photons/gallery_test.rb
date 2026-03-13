require "test_helper"

module BeautifulPhotons
  class GalleryTest < ActiveSupport::TestCase
    test "valid with name and title" do
      gallery = Gallery.new(name: "homepage_hero", title: "Homepage Hero")
      assert gallery.valid?
    end

    test "invalid without name" do
      gallery = Gallery.new(title: "Homepage Hero")
      assert_not gallery.valid?
      assert_includes gallery.errors[:name], "can't be blank"
    end
  end
end
