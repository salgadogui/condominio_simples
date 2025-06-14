class CreateBuildings < ActiveRecord::Migration[8.0]
  def change
    create_table :buildings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :address_street
      t.string :address_number
      t.string :address_district
      t.string :address_city
      t.string :cep

      t.timestamps
    end
  end
end
