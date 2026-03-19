require "test_helper"

module BeautifulPhotons
  class CategoryTest < ActiveSupport::TestCase
    test "valid with a name" do
      category = Category.new(name: "Backsplashes")
      assert category.valid?
    end

    test "invalid without a name" do
      category = Category.new(name: nil)
      assert_not category.valid?
      assert_includes category.errors[:name], "can't be blank"
    end

    test "name must be unique" do
      Category.create!(name: "Floors")
      duplicate = Category.new(name: "Floors")
      assert_not duplicate.valid?
      assert_includes duplicate.errors[:name], "has already been taken"
    end
  end
end
