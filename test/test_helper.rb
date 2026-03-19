# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
require "rails/test_help"

ActionController::Base.allow_forgery_protection = false

class ActiveSupport::TestCase
  self.use_transactional_tests = true
  self.file_fixture_path = File.expand_path("fixtures/files", __dir__)
end
