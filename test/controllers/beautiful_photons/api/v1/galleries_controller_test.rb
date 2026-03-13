require "test_helper"

module BeautifulPhotons
  module Api
    module V1
      class GalleriesControllerTest < ActionDispatch::IntegrationTest
        include Engine.routes.url_helpers

        setup do
          @routes = Engine.routes
        end

        test "POST /api/v1/galleries creates a gallery" do
          assert_difference("BeautifulPhotons::Gallery.count", 1) do
            post api_v1_galleries_url, params: {
              gallery: { name: "portfolio", title: "Portfolio", description: "Our work" }
            }
          end

          assert_response :created

          json = JSON.parse(response.body)
          assert_equal "portfolio", json["name"]
          assert_equal "Portfolio", json["title"]
          assert_equal "Our work", json["description"]
        end

        test "GET /api/v1/galleries returns list of galleries" do
          Gallery.create!(name: "homepage", title: "Homepage")

          get api_v1_galleries_url

          assert_response :ok

          json = JSON.parse(response.body)
          assert_equal 1, json.length
          assert_equal "homepage", json.first["name"]
        end
      end
    end
  end
end
