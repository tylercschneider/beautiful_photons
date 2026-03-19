# frozen_string_literal: true

require "rails/generators"

module BeautifulPhotons
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Install BeautifulPhotons photo gallery engine"

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
