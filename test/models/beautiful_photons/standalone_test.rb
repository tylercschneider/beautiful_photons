require "test_helper"

module BeautifulPhotons
  class StandaloneTest < ActiveSupport::TestCase
    test "valid with key" do
      standalone = Standalone.new(key: "about_hero")
      assert standalone.valid?
    end

    test "invalid without key" do
      standalone = Standalone.new
      assert_not standalone.valid?
      assert_includes standalone.errors[:key], "can't be blank"
    end

    test "enforces unique key" do
      Standalone.create!(key: "about_hero")
      duplicate = Standalone.new(key: "about_hero")
      assert_not duplicate.valid?
      assert_includes duplicate.errors[:key], "has already been taken"
    end

    test "generates label from key when blank" do
      standalone = Standalone.new(key: "about_hero")
      standalone.valid?
      assert_equal "About hero", standalone.label
    end

    test "keeps custom label when provided" do
      standalone = Standalone.new(key: "about_hero", label: "About Page Photo")
      standalone.valid?
      assert_equal "About Page Photo", standalone.label
    end

    test "belongs to photo optionally" do
      standalone = Standalone.new(key: "about_hero")
      assert standalone.valid?
      assert_nil standalone.photo
    end
  end
end
