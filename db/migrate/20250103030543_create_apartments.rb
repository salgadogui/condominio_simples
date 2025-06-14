class CreateApartments < ActiveRecord::Migration[8.0]
  def change
    create_table :apartments do |t|
      t.references :block, null: false, foreign_key: true
      t.string :number, null: false
      t.decimal :rent_amount, null: false

      t.timestamps
    end
  end
end
