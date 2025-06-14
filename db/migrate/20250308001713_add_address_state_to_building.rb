class AddAddressStateToBuilding < ActiveRecord::Migration[8.0]
  def change
    add_column :buildings, :address_state, :string, null: false
  end
end
