module BeautifulPhotons
  class Photo < ApplicationRecord
    has_one_attached :image
    has_many :gallery_photos, dependent: :destroy
    has_many :galleries, through: :gallery_photos

    validates :image, presence: true
    validates :focal_x, :focal_y, numericality: { in: 0..100 }
    validates :mobile_focal_x, :mobile_focal_y, numericality: { in: 0..100 }, allow_nil: true

    scope :published, -> { where(published: true) }

    def effective_mobile_focal_x
      mobile_focal_x || focal_x
    end

    def effective_mobile_focal_y
      mobile_focal_y || focal_y
    end
  end
end
