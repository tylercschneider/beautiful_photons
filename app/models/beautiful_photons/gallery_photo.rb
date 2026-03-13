module BeautifulPhotons
  class GalleryPhoto < ApplicationRecord
    belongs_to :gallery
    belongs_to :photo

    validates :position, presence: true
  end
end
