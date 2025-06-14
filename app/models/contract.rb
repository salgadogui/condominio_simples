class Contract < ApplicationRecord
  belongs_to :apartment
  belongs_to :landlord, class_name: "User"
  belongs_to :tenant, class_name: "User"
  has_many :billings, dependent: :destroy

  enum :status, { active: 0, expired: 1, cancelled: 2 }

  validates :apartment_id, :landlord_id, :tenant_id,
           :start_date, :end_date,
           presence: true

  validate :only_one_active_contract_per_apartment

  private

  def only_one_active_contract_per_apartment
    return unless active?

    existing_active_contract = Contract.where(apartment_id: apartment_id, status: :active).where.not(id: id).exists?

    if existing_active_contract
      errors.add(:apartment_id, "já possui um contrato ativo")
    end
  end
end
