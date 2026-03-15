# frozen_string_literal: true

require "test_helper"

module BeautifulPhotons
  module Admin
    class GalleriesControllerTest < ActionDispatch::IntegrationTest
      include Engine.routes.url_helpers

      setup do
        @routes = Engine.routes
      end

      test "GET /admin/galleries renders the gallery list" do
        gallery = BeautifulPhotons::Gallery.create!(name: "homepage", title: "Homepage Gallery")

        get admin_galleries_url

        assert_response :ok
        assert_select "h1", "Galleries"
        assert_select "a", "Homepage Gallery"
      end
    end
  end
end
