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

        test "GET /api/v1/galleries/:id returns a single gallery" do
          gallery = Gallery.create!(name: "services", title: "Services")

          get api_v1_gallery_url(gallery)

          assert_response :ok

          json = JSON.parse(response.body)
          assert_equal "services", json["name"]
          assert_equal gallery.id, json["id"]
        end

        test "PATCH /api/v1/galleries/:id updates a gallery" do
          gallery = Gallery.create!(name: "old_name", title: "Old Title")

          patch api_v1_gallery_url(gallery), params: {
            gallery: { title: "New Title", description: "Updated" }
          }

          assert_response :ok

          json = JSON.parse(response.body)
          assert_equal "New Title", json["title"]
          assert_equal "Updated", json["description"]
        end

        test "DELETE /api/v1/galleries/:id destroys a gallery" do
          gallery = Gallery.create!(name: "to_delete", title: "Delete Me")

          assert_difference("BeautifulPhotons::Gallery.count", -1) do
            delete api_v1_gallery_url(gallery)
          end

          assert_response :no_content
        end

        test "POST /api/v1/galleries returns 422 without title" do
          post api_v1_galleries_url, params: { gallery: { description: "No title" } }

          assert_response :unprocessable_entity

          json = JSON.parse(response.body)
          assert_includes json["errors"], "Title can't be blank"
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
