class AddLandlordIdToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :landlord_id, :integer
    add_foreign_key :users, :users, column: :landlord_id
    add_index :users, :landlord_id
  end
end
