class AddStatusEnumToContract < ActiveRecord::Migration[8.0]
  def change
    add_column :contracts, :status, :integer, null: false, default: 0
  end
end
