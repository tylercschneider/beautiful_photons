class AddCategoryToBeautifulPhotonsPhotos < ActiveRecord::Migration[8.1]
  def change
    add_reference :beautiful_photons_photos, :category, null: true,
      foreign_key: { to_table: :beautiful_photons_categories }
  end
end
