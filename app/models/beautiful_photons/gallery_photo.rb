module BeautifulPhotons
  class GalleryPhoto < ApplicationRecord
    belongs_to :gallery
    belongs_to :photo

    validates :position, presence: true
    validates :photo_id, uniqueness: { scope: %i[gallery_id category] }
  end
end
