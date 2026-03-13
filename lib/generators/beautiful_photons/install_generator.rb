# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module BeautifulPhotons
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      desc "Install BeautifulPhotons photo gallery engine"

      def copy_migrations
        migration_template "create_beautiful_photons_photos.rb.tt", "db/migrate/create_beautiful_photons_photos.rb"
        migration_template "create_beautiful_photons_galleries.rb.tt", "db/migrate/create_beautiful_photons_galleries.rb"
        migration_template "create_beautiful_photons_gallery_photos.rb.tt",
                           "db/migrate/create_beautiful_photons_gallery_photos.rb"
      end

      def mount_engine
        route 'mount BeautifulPhotons::Engine => "/beautiful_photons"'
      end

      def print_instructions
        say ""
        say "BeautifulPhotons installed successfully!", :green
        say ""
        say "Next steps:"
        say "  1. Run migrations: rails db:migrate"
        say ""
      end
    end
  end
end
