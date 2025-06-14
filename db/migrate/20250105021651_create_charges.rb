class CreateCharges < ActiveRecord::Migration[8.0]
  def change
    create_table :charges do |t|
      t.references :billing, null: false, foreign_key: true
      t.string :description, null: false
      t.decimal :amount, null: false
      t.integer :type, null: false, default: 0

      t.timestamps
    end
  end
end
