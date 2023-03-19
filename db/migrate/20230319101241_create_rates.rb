class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :value
      t.references :rateable, polymorphic: true

      t.timestamps
    end
  end
end
