# frozen_string_literal: true

require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)
require "beautiful_photons"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    config.root = File.expand_path("..", __dir__)
    config.secret_key_base = "test_secret_key_base_for_beautiful_photons_gem"
    config.active_storage.service = :test

    # Schema is loaded directly in test_helper — don't check engine migrations
    config.active_record.migration_error = false
  end
end
