require "test_helper"

module BeautifulPhotons
  class GalleryTest < ActiveSupport::TestCase
    test "valid with name and title" do
      gallery = Gallery.new(name: "homepage_hero", title: "Homepage Hero")
      assert gallery.valid?
    end
  end
end
