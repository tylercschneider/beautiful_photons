module BeautifulPhotons
  class Gallery < ApplicationRecord
    has_many :gallery_photos, dependent: :destroy
    has_many :photos, through: :gallery_photos

    validates :name, presence: true, uniqueness: true
    validates :title, presence: true
  end
end
