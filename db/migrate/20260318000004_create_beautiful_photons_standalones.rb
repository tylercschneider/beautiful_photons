class CreateBeautifulPhotonsStandalones < ActiveRecord::Migration[8.1]
  def change
    create_table :beautiful_photons_standalones do |t|
      t.string :key, null: false
      t.string :label
      t.references :photo, foreign_key: { to_table: :beautiful_photons_photos }

      t.timestamps
    end

    add_index :beautiful_photons_standalones, :key, unique: true
  end
end
