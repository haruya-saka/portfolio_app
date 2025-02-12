class CreateWorkImages < ActiveRecord::Migration[8.0]
  def change
    create_table :work_images do |t|
      t.references :work, null: false, foreign_key: true
      t.string :image_url
      t.string :orientation

      t.timestamps
    end
  end
end
