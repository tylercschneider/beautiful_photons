class CreateBeautifulPhotonsCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :beautiful_photons_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :beautiful_photons_categories, :name, unique: true
  end
end
