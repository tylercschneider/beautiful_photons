require "test_helper"
require "rails/generators/test_case"
require "generators/beautiful_photons/install_generator"

class BeautifulPhotons::InstallGeneratorTest < Rails::Generators::TestCase
  tests BeautifulPhotons::Generators::InstallGenerator
  destination File.expand_path("../../tmp/generator_test", __dir__)

  setup do
    prepare_destination
    FileUtils.mkdir_p(File.join(destination_root, "config"))
    File.write(
      File.join(destination_root, "config/routes.rb"),
      "Rails.application.routes.draw do\nend\n"
    )
  end

  test "mounts engine at /photos by default" do
    run_generator
    assert_file "config/routes.rb", /mount BeautifulPhotons::Engine.*"\/photos"/
  end
end
