module BeautifulPhotons
  class Gallery < ApplicationRecord
    validates :name, presence: true
    validates :title, presence: true
  end
end
