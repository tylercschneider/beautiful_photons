require "test_helper"

module BeautifulPhotons
  class GalleryTest < ActiveSupport::TestCase
    test "valid with name and title" do
      gallery = Gallery.new(name: "homepage_hero", title: "Homepage Hero")
      assert gallery.valid?
    end

    test "auto-generates name from title when blank" do
      gallery = Gallery.new(title: "Homepage Hero")
      gallery.valid?
      assert_equal "homepage_hero", gallery.name
    end

    test "invalid without title" do
      gallery = Gallery.new(name: "homepage_hero")
      assert_not gallery.valid?
      assert_includes gallery.errors[:title], "can't be blank"
    end

    test "enforces unique name" do
      Gallery.create!(name: "homepage_hero", title: "Homepage Hero")
      duplicate = Gallery.new(name: "homepage_hero", title: "Another Hero")
      assert_not duplicate.valid?
      assert_includes duplicate.errors[:name], "has already been taken"
    end
  end
end
