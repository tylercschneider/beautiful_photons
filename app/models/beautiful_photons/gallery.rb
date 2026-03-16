module BeautifulPhotons
  class Gallery < ApplicationRecord
    has_many :gallery_photos, dependent: :destroy
    has_many :photos, through: :gallery_photos

    validates :name, presence: true, uniqueness: true
    validates :title, presence: true

    before_validation :generate_name, if: -> { name.blank? && title.present? }

    private

    def generate_name
      self.name = title.parameterize(separator: "_")
    end
  end
end
