module BeautifulPhotons
  class GalleryPhoto < ApplicationRecord
    belongs_to :gallery
    belongs_to :photo
  end
end
