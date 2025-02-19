class CreateWorkImages < ActiveRecord::Migration[8.0]
  def change
    create_table :work_images do |t|
      t.integer :work_id
      t.string :image_url

      t.timestamps
    end

    add_index :work_images, :work_id
  end
end
