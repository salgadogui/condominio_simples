class Charge < ApplicationRecord
  belongs_to :billing

  validates :amount, presence: true

  enum :charge_type, [ :common, :block, :rent, :extras ]
end
