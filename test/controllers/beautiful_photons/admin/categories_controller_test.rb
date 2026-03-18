# frozen_string_literal: true

require "test_helper"

module BeautifulPhotons
  module Admin
    class CategoriesControllerTest < ActionDispatch::IntegrationTest
      include Engine.routes.url_helpers

      setup do
        @routes = Engine.routes
      end

      test "GET /categories renders the category list" do
        BeautifulPhotons::Category.create!(name: "Backsplashes")

        get categories_url

        assert_response :ok
        assert_select "h1", "Categories"
        assert_match "Backsplashes", response.body
      end

      test "POST /categories creates a category and redirects" do
        assert_difference("BeautifulPhotons::Category.count", 1) do
          post categories_url, params: { category: { name: "Floors" } }
        end

        assert_redirected_to categories_path
        assert_equal "Category created.", flash[:notice]
      end
    end
  end
end
