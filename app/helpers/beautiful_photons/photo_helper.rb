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

      options[:alt] ||= photo.title
      image_tag(url_for(photo.image), **options.merge(style: style))
    end

    def beautiful_photons_photo(key, **options, &block)
      standalone = Standalone.find_or_create_by!(key: key.to_s)
      return beautiful_photons_placeholder(**options, &block) unless standalone.photo

      cache_key = [ "bp/photo", standalone.cache_key_with_version, standalone.photo.cache_key_with_version ]
      rendered = Rails.cache.fetch(cache_key) do
        photo = standalone.photo
        img = beautiful_photons_image(photo, **options.merge(
          style: [ options[:style], "opacity: 0; transition: opacity 0.3s" ].compact.join("; "),
          onload: "this.style.opacity=1;this.previousElementSibling.style.display='none'",
          onerror: "this.style.display='none';this.parentElement.querySelector('.bp-fallback').style.display='flex'"
        ))

        fallback = beautiful_photons_placeholder(**options.merge(class: [ options[:class], "bp-fallback" ].compact.join(" ")),
          &block)

        content_tag(:div, class: "bp-photo", style: "position: relative; width: 100%; height: 100%;") do
          beautiful_photons_loader + img + content_tag(:div, fallback, style: "display: none; position: absolute; inset: 0;")
        end
      end

      beautiful_photons_inline_styles + rendered
    end

    def beautiful_photons_inline_styles
      return "".html_safe if @_bp_styles_rendered
      @_bp_styles_rendered = true
      content_tag(:style) { "@keyframes bp-spin { to { transform: rotate(360deg); } }".html_safe }
    end

    def beautiful_photons_loader
      content_tag(:div, class: "bp-loader",
        style: "position: absolute; inset: 0; display: flex; align-items: center; justify-content: center; background: #1a1a1a; z-index: 1; color: currentColor;") do
        content_tag(:svg, viewBox: "0 0 24 24", style: "width: 33%; max-width: 48px; height: auto; animation: bp-spin 1s linear infinite;",
          fill: "none", xmlns: "http://www.w3.org/2000/svg") do
          tag(:circle, cx: "12", cy: "12", r: "10", stroke: "currentColor", "stroke-width": "2", opacity: "0.25") +
            tag(:path, d: "M12 2a10 10 0 0 1 10 10", stroke: "currentColor", "stroke-width": "2", "stroke-linecap": "round")
        end
      end
    end

    def beautiful_photons_placeholder(**options, &block)
      css_class = [ "bp-placeholder", options[:class] ].compact.join(" ")
      content_tag(:div, class: css_class,
        style: "display: flex; align-items: center; justify-content: center; background: #1a1a1a; color: currentColor; width: 100%; height: 100%; overflow: hidden;") do
        if block
          capture(&block)
        else
          content_tag(:svg, xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24",
            "stroke-width": "0.75", stroke: "currentColor", class: "bp-placeholder-icon",
            style: "width: 33%; max-width: 120px; height: auto;") do
            tag(:path, "stroke-linecap": "round", "stroke-linejoin": "round",
              d: "m2.25 15.75 5.159-5.159a2.25 2.25 0 0 1 3.182 0l5.159 5.159m-1.5-1.5 1.409-1.409a2.25 2.25 0 0 1 3.182 0l2.909 2.909M3.75 21h16.5A2.25 2.25 0 0 0 22.5 18.75V5.25A2.25 2.25 0 0 0 20.25 3H3.75A2.25 2.25 0 0 0 1.5 5.25v13.5A2.25 2.25 0 0 0 3.75 21Z")
          end
        end
      end
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
