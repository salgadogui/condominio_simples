class AddStatusToBilling < ActiveRecord::Migration[8.0]
  def change
    add_column :billings, :status, :integer, null: false, default: 0
  end
end
