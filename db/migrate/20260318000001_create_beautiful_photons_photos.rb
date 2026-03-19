class CreateBeautifulPhotonsPhotos < ActiveRecord::Migration[8.1]
  def change
    create_table :beautiful_photons_photos do |t|
      t.string :title
      t.text :description
      t.decimal :focal_x, default: 50.0, null: false
      t.decimal :focal_y, default: 50.0, null: false
      t.decimal :mobile_focal_x
      t.decimal :mobile_focal_y
      t.boolean :published, default: false, null: false

      t.timestamps
    end
  end
end
