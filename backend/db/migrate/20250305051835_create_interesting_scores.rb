class CreateInterestingScores < ActiveRecord::Migration[8.0]
  def change
    create_table :interesting_scores do |t|
      t.references :subject_user, null: false, foreign_key: { to_table: :users }
      t.references :target_user, null: false, foreign_key: { to_table: :users }
      t.integer :score, default: 0, null: false

      t.timestamps
    end
    add_index :interesting_scores, [:subject_user_id, :target_user_id], unique: true
  end
end