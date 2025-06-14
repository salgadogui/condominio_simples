class RenameChargeTypeColumnToChargeType < ActiveRecord::Migration[8.0]
  def change
    rename_column :charges, :type, :charge_type
  end
end
