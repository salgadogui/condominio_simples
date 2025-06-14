class CreateContracts < ActiveRecord::Migration[8.0]
  def change
    create_table :contracts do |t|
      t.references :apartment, null: false, foreign_key: true
      t.references :landlord, null: false, foreign_key: { to_table: :users }
      t.references :tenant, null: false, foreign_key: { to_table: :users }
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
