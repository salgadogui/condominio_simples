class Block < ApplicationRecord
  belongs_to :building
  has_many :apartments, dependent: :destroy

  validates :name, :building_id, presence: true
end
