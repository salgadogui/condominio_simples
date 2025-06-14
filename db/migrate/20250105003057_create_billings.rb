class CreateBillings < ActiveRecord::Migration[8.0]
  def change
    create_table :billings do |t|
      t.references :contract, null: false, foreign_key: true
      t.date :billing_reference_date
      t.date :rent_reference_date
      t.decimal :amount

      t.timestamps
    end
  end
end
