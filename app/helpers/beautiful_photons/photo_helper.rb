module BeautifulPhotons
  module PhotoHelper
    def beautiful_photons_image(photo, **options)
      style = "object-fit: cover; object-position: #{photo.focal_x.to_f}% #{photo.focal_y.to_f}%"

      if options[:style]
        style = "#{style}; #{options.delete(:style)}"
      else
        options.delete(:style)
      end

      image_tag(url_for(photo.image), **options.merge(style: style))
    end
  end
end
