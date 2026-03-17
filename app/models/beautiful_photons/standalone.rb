module BeautifulPhotons
  class Standalone < ApplicationRecord
    belongs_to :photo, optional: true

    validates :key, presence: true, uniqueness: true

    before_validation :generate_label, if: -> { label.blank? && key.present? }

    private

    def generate_label
      self.label = key.humanize
    end
  end
end
