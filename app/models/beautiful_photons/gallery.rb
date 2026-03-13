module BeautifulPhotons
  class Gallery < ApplicationRecord
    validates :name, presence: true
  end
end
