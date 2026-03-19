class CreateBeautifulPhotonsGalleries < ActiveRecord::Migration[8.1]
  def change
    create_table :beautiful_photons_galleries do |t|
      t.string :name, null: false
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :beautiful_photons_galleries, :name, unique: true
  end
end
