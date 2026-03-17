require "test_helper"

module BeautifulPhotons
  class StandaloneCropTest < ActiveSupport::TestCase
    test "defaults crop to center with no zoom" do
      standalone = Standalone.new(key: "test")
      assert_equal 50.0, standalone.crop_x
      assert_equal 50.0, standalone.crop_y
      assert_equal 1.0, standalone.crop_zoom
    end
  end
end
