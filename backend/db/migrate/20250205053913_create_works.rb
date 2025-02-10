class CreateWorks < ActiveRecord::Migration[8.0]
  def change
    create_table :works do |t|
      t.string :title
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :works, [:user_id, :created_at]
  end
end
