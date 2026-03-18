module BeautifulPhotons
  class GalleryPhoto < ApplicationRecord
    belongs_to :gallery
    belongs_to :photo

    validates :position, presence: true
    validates :photo_id, uniqueness: { scope: %i[gallery_id category] }

    after_create :publish_photo
    after_destroy :unpublish_photo

    private

    def publish_photo
      photo.update_published!
    end

    def unpublish_photo
      photo.update_published!
    end
  end
end
