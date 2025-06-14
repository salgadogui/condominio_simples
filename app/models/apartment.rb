class Apartment < ApplicationRecord
  belongs_to :block
  has_one :building, through: :block
  has_many :contracts, dependent: :destroy

  validates :block_id, :number, :rent_amount, presence: true
end
