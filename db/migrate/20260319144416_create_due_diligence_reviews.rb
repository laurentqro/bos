class CreateDueDiligenceReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :due_diligence_reviews do |t|
      t.references :client, null: false, foreign_key: true
      t.string :review_type, null: false
      t.string :trigger, null: false
      t.date :performed_at, null: false
      t.text :notes

      t.timestamps
    end
  end
end
