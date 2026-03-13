module BeautifulPhotons
  class Gallery < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :title, presence: true
  end
end
