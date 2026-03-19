require_relative "lib/beautiful_photons/version"

Gem::Specification.new do |spec|
  spec.name        = "beautiful_photons"
  spec.version     = BeautifulPhotons::VERSION
  spec.authors     = [ "Tyler Schneider" ]
  spec.email       = [ "tylercschneider@gmail.com" ]
  spec.homepage    = "https://github.com/tylercschneider/beautiful_photons"
  spec.summary     = "Photo gallery engine for Rails with focal-point cropping."
  spec.description = "A mountable Rails engine for managing photo galleries with responsive focal-point cropping, named galleries, and an API for uploads."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tylercschneider/beautiful_photons"
  spec.metadata["changelog_uri"] = "https://github.com/tylercschneider/beautiful_photons/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 8.1.2"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "keystone_ui", ">= 0.4.1"
end
