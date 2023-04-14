class CreateSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, null: false, foreign_key: { to_table: :users }
      t.references :question, null: false, foreign_key: true

      t.index [:subscriber_id, :question_id], unique: true
      
      t.timestamps
    end
  end
end
