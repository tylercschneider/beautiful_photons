class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def authenticate_user!
    # No-op for dummy app tests
  end

  def authenticate_api_user!
    token = request.headers["Authorization"]&.delete_prefix("token ")
    head :unauthorized unless token == "test-api-token"
  end
end
