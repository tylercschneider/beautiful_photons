module BeautifulPhotons
  module PhotoHelper
    def beautiful_photons_image(photo, **options)
      style = "object-fit: cover; object-position: #{photo.focal_x.to_f}% #{photo.focal_y.to_f}%"

      if (aspect = options.delete(:aspect))
        style = "#{style}; aspect-ratio: #{aspect}"
      end

      if options[:style]
        style = "#{style}; #{options.delete(:style)}"
      end

      if photo.mobile_focal_x.present?
        options[:data] = (options[:data] || {}).merge(
          mobile_focal_x: photo.effective_mobile_focal_x.to_f,
          mobile_focal_y: photo.effective_mobile_focal_y.to_f
        )
      end

      image_tag(url_for(photo.image), **options.merge(style: style))
    end

    def beautiful_photons_gallery(gallery_name)
      gallery = Gallery.find_by!(name: gallery_name)
      photos = gallery.gallery_photos.order(:position).map(&:photo)
      photos.each { |photo| yield photo }
    end

    def beautiful_photons_photos(gallery_name, category: nil)
      gallery = Gallery.find_by!(name: gallery_name)
      scope = gallery.gallery_photos.order(:position)
      scope = scope.where(category: category) if category
      scope.map(&:photo)
    end
  end
end
