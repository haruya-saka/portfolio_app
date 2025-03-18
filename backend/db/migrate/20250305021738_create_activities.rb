class CreateActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.references :performer, null: false, foreign_key: { to_table: :users }
      t.references :target, polymorphic: true, null: false

      t.timestamps
    end
  end
end