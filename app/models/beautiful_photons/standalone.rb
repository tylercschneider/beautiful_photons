module BeautifulPhotons
  class Standalone < ApplicationRecord
    belongs_to :photo, optional: true

    validates :key, presence: true, uniqueness: true

    before_validation :generate_label, if: -> { label.blank? && key.present? }
    after_save :update_photo_published, if: :saved_change_to_photo_id?
    after_destroy :update_photo_published

    private

    def generate_label
      self.label = key.humanize
    end

    def update_photo_published
      old_id, new_id = saved_change_to_photo_id || [photo_id, nil]
      Photo.find_by(id: old_id)&.update_published! if old_id
      Photo.find_by(id: new_id)&.update_published! if new_id
    end
  end
end
