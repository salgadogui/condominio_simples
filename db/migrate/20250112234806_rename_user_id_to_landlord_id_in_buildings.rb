class RenameUserIdToLandlordIdInBuildings < ActiveRecord::Migration[8.0]
  def change
    rename_column :buildings, :user_id, :landlord_id
  end
end
